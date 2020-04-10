
#import "JSLNetworkViewController.h"

@interface JSLNetworkViewController ()

@end

@implementation JSLNetworkViewController

#pragma mark - 视图生命周期（加载视图）
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册监听网络状态
    [self addNetworkReachabilityNotificationReceive];
    
    // 根据网络状态处理
    [self currentNetworkReachabilityStatus:[JSLNetworkReachabilityUtil currentNetworktatus] inViewController:self];
}

#pragma mark - 注册监听网络状态
- (void)addNetworkReachabilityNotificationReceive
{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(doNotificationReceiveWithNetworkReachabilityStatus:)
                               name:JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY
                             object:nil
     ];
}

#pragma mark 通知事件处理：网络状态变化
- (void)doNotificationReceiveWithNetworkReachabilityStatus:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *networkReachabilityStatus = (NSNumber *)userInfo[JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_KEY];
    [self currentNetworkReachabilityStatus:networkReachabilityStatus.integerValue inViewController:self];
    /*
    UIViewController *topViewController = [JSLAppUtil getTopViewController];
    if ([topViewController isKindOfClass:[self class]]) {
        [self currentNetworkReachabilityStatus:networkReachabilityStatus.integerValue inViewController:self];
    }
    */
}

#pragma mark - JSLNetworkViewControllerProtocol

- (void)currentNetworkReachabilityStatus:(JSLNetworkStatus)currentNetworkStatus inViewController:(JSLNetworkViewController *)inViewController
{
    switch (currentNetworkStatus) {
        case JSLNetworkStatusUnknown:
        case JSLNetworkStatusNotReachable: {
            
            // 再判断一下网络状态，因为AFNetworking网络监听延迟
            if (![JSLNetworkReachabilityUtil isNetworkAvailable]) {
                
                // 根据网络状态进行加载处理
                [self viewDidLoadWithNoNetworkingStatus];
                
                [JSLProgressAlertUtil showMessage:@"网络开小差啦，请检查网络设置" toView:self.view];
            }
            
            break;
        }
        case JSLNetworkStatusReachableViaWWAN:
        case JSLNetworkStatusReachableViaWiFi: {
            
            // 根据网络状态进行加载处理
            [self viewDidLoadWithNetworkingStatus];
            
            break;
        }
        default: {
            
            break;
        }
    }
}

- (void)dealloc
{
    if ([self isViewLoaded]) {
        [JSLProgressAlertUtil hideHUDForView:self.view];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY object:nil];
}



#pragma mark - 私有方法

#pragma mark 监听网络变化后执行 - 有网络
- (void)viewDidLoadWithNetworkingStatus
{
    
}

#pragma mark 监听网络变化后执行 - 无网络
- (void)viewDidLoadWithNoNetworkingStatus
{
    
}


@end


