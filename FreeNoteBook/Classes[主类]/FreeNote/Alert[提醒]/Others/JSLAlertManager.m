
#import "JSLAlertManager.h"
#import "JSLAlertViewController.h"

@interface JSLAlertManager()

@property (nonatomic, strong) JSLAlertHandler *handler;
@property (nonatomic, strong) dispatch_queue_t localNotificationQueue;

@end

const char *localNotificationQueue = "cn.hansen.freenote.localNotificationQueue";

@implementation JSLAlertManager

+ (instancetype)sharedManager
{
    static JSLAlertManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self autoCheckToAddAlert];
        [self autoCheckToMarkFinish];
    }
    
    return self;
}

- (void)fetchAlertInfosWithResult:(JSLResultBlock)resultBlock
{
    [self.handler fetchAlertInfosWithResult:resultBlock];
}

- (void)cacheAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    [self.handler cacheAlertInfo:alertInfo result:^{
        dispatch_async_in_queue(self.localNotificationQueue, ^{
            //异步处理通知
            [weakSelf pushAlertToLocalNotification:alertInfo];
        });
        //先直接在主线程回调
        if (resultBlock) {
            resultBlock();
        }
    }];
}

- (void)updateAlertIsJoined:(BOOL)isJoined alertId:(NSInteger)alertId result:(void (^)(void))resultBlock;
{
    [self.handler updateAlertIsJoined:isJoined alertId:alertId result:resultBlock];
}

- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock
{
    [self.handler updateAlertIsCompleteWithAlertId:alertId result:resultBlock];

}

- (void)deleteAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    [self cancelNotifiWithAlertInfo:alertInfo];
    [self.handler deleteAlertInfo:alertInfo result:resultBlock];
}

- (JSLAlertHandler *)handler
{
    if (!_handler) {
        _handler = [[JSLAlertHandler alloc] init];
    }
    
    return _handler;
}

- (dispatch_queue_t)localNotificationQueue
{
    if (!_localNotificationQueue) {
        _localNotificationQueue = dispatch_create_serial_queue_for_name(localNotificationQueue);
    }

    return _localNotificationQueue;
}

#pragma mark - UILocalNotification

- (void)autoCheckToAddAlert
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.localNotificationQueue, ^{
        [weakSelf.handler fetchUnJoinedAlertInfosWithResult:^(JSLResult *result) {
            NSArray *alertInfos = result.result;
            if (alertInfos.count == 0) {
                return;
            }
            
            for (JSLAlertInfo *alertInfo in alertInfos) {
                [weakSelf pushAlertToLocalNotification:alertInfo];
            }
        }];
    });
}

//对于已过期的提醒并且是从不重复的提醒手动标记为已过期
- (void)autoCheckToMarkFinish
{
    [self.handler autoCheckToMarkFinish];

}

- (void)pushAlertToLocalNotification:(JSLAlertInfo *)alertInfo
{
    if (alertInfo.alertId > 0) {//数据库插入成功
        //已添加到系统通知队列的通知
        NSArray *scheduledNotis = [UIApplication sharedApplication].scheduledLocalNotifications;
        if (scheduledNotis.count < 64) {
            //队列没满，可以直接加入
            [self addNotification:alertInfo];
        } else {
            //队列满了，需要踢除开始时间最晚的通知 再加入
            UILocalNotification *latestNotifi = nil;
            for (UILocalNotification *notifi in scheduledNotis) {
                if([latestNotifi.fireDate compare:notifi.fireDate] == NSOrderedAscending) {
                    latestNotifi = notifi;
                }
            }
            
            if ([latestNotifi.fireDate compare:alertInfo.alertDate] == NSOrderedDescending) {
                [self removeNotification:latestNotifi];
                [self addNotification:alertInfo];
            }
        }
    }
}

- (void)addNotification:(JSLAlertInfo *)alertInfo
{
    UILocalNotification *notifaction = [[UILocalNotification alloc] init];
    
    //保证alertBody不能为空 不然的话通知会显示不出来
    if (alertInfo.alertRemark.length == 0) {
        notifaction.alertBody = alertInfo.alertName;
    } else {
        if (@available(iOS 8.2, *)) {
            notifaction.alertTitle = alertInfo.alertName;
        } else {
            // Fallback on earlier versions
        }
        notifaction.alertBody = alertInfo.alertRemark;
    }
    
    notifaction.fireDate = alertInfo.alertDate;
    notifaction.repeatInterval = (NSInteger)alertInfo.alertRepeatType;
    notifaction.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@(alertInfo.alertId)
                                                        forKey:@"freenote_alertId"];
    notifaction.userInfo = infoDic;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notifaction];
    
    //更新内存
    alertInfo.joinLocalNotification = YES;
    //更新数据库
    [self updateAlertIsJoined:YES alertId:alertInfo.alertId result:nil];
}

- (void)removeNotification:(UILocalNotification *)notifi
{
    [[UIApplication sharedApplication] cancelLocalNotification:notifi];
    NSDictionary *userInfoDic = notifi.userInfo;
    NSNumber *alertId = [userInfoDic objectForKey:@"freenote_alertId"];
    [self updateAlertIsJoined:NO alertId:alertId.integerValue result:nil];
}

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *localNotify = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotify)
    {
        [self didReceiveLocalNotification:localNotify];
    }
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSNumber *alertId = [notification.userInfo objectForKey:@"freenote_alertId"];
    __weak typeof(self) weakSelf = self;
    [self.handler selectAlertInfoWithAlertId:alertId.integerValue result:^(JSLResult *result) {
        [weakSelf showAlertViewWithInfo:result.result];
        if (((JSLAlertInfo *)result.result).alertRepeatType == kJSLAlertRepeatTypeNever) {
            // 不再重复执行的提醒才标记为已完成
            [weakSelf.handler updateAlertIsFinishedwithAlertId:alertId.integerValue result:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:alertStateChangedNotification object:nil];
            }];
        }
        
        [weakSelf autoCheckToAddAlert];
    }];
}

- (void)showAlertViewWithInfo:(JSLAlertInfo *)alertInfo
{
    if (nil == alertInfo) {
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:alertInfo.alertName
                                                                     message:alertInfo.alertRemark
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alertVC addAction:confirmAction];
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    [vc presentViewController:alertVC animated:YES completion:nil];
}

- (void)cancelNotifiWithAlertInfo:(JSLAlertInfo *)alertInfo
{
    NSArray *scheduledNotis = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *noti in scheduledNotis) {
        NSNumber *alertId = [noti.userInfo objectForKey:@"freenote_alertId"];
        if (alertId.integerValue == alertInfo.alertId) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            break;
        }
    }
}

@end
