
#import "JSLNetworkReachabilityUtil.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworkReachabilityManager.h>
#else
#import "AFNetworkReachabilityManager.h"
#endif

#pragma mark 监听网络状态变动的广播通知频段
NSString * const JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY = @"JSLNetworkReachabilityUtilNetWorkingStatusFrequency";
#pragma mark 监听网络状态变动的广播通知内容 - 字典KEY
NSString * const JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_KEY = @"JSLNetworkReachabilityUtilNetWorkingStatusKey";


@interface JSLNetworkReachabilityUtil ()

@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@property (nonatomic, assign) JSLNetworkStatus networktatus;

@end


@implementation JSLNetworkReachabilityUtil

#pragma mark - 网络管理单例
+ (void)load
{
    // 开启网络监听
    [[self class] currentNetworktatus];
}

#pragma mark - 网络管理单例
+ (instancetype)sharedNetworkUtilsWithCurrentReachabilityStatusBlock:(JSLCurrentReachabilityStatusBlock)currentReachabilityStatusBlock
{
    static JSLNetworkReachabilityUtil *_singetonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (nil == _singetonInstance) {
            // 网络请求管理单例
            _singetonInstance = [[super allocWithZone:NULL] init];
            // 网络请求Session
            _singetonInstance.manager = [AFNetworkReachabilityManager sharedManager];
            [_singetonInstance.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusUnknown: {
                        // 打印日志
                        JSLLog(@"未识别的网络");
                        !currentReachabilityStatusBlock?:currentReachabilityStatusBlock(JSLNetworkStatusUnknown);
                        // 网络状态
                        _singetonInstance.networktatus = JSLNetworkStatusUnknown;
                        // 发送通知
                        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                        [notificationCenter postNotificationName:JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY
                                                          object:self
                                                        userInfo:@{JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_KEY:@(JSLNetworkStatusUnknown)}];
                        break;
                    }
                    case AFNetworkReachabilityStatusNotReachable: {
                        // 打印日志
                        JSLLog(@"不可达的网络(未连接)");
                        !currentReachabilityStatusBlock?:currentReachabilityStatusBlock(JSLNetworkStatusNotReachable);
                        // 网络状态
                        _singetonInstance.networktatus = JSLNetworkStatusNotReachable;
                        // 发送通知
                        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                        [notificationCenter postNotificationName:JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY
                                                          object:self
                                                        userInfo:@{JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_KEY:@(JSLNetworkStatusNotReachable)}];
                        break;
                    }
                    case AFNetworkReachabilityStatusReachableViaWWAN: {
                        // 打印日志
                        JSLLog(@"2G,3G,4G...的网络");
                        !currentReachabilityStatusBlock?:currentReachabilityStatusBlock(JSLNetworkStatusReachableViaWWAN);
                        // 网络状态
                        _singetonInstance.networktatus = JSLNetworkStatusReachableViaWWAN;
                        // 发送通知
                        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                        [notificationCenter postNotificationName:JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY
                                                          object:self
                                                        userInfo:@{JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_KEY:@(JSLNetworkStatusReachableViaWWAN)}];
                        break;
                    }
                    case AFNetworkReachabilityStatusReachableViaWiFi: {
                        // 打印日志
                        JSLLog(@"WIFI的网络");
                        !currentReachabilityStatusBlock?:currentReachabilityStatusBlock(JSLNetworkStatusReachableViaWiFi);
                        // 网络状态
                        _singetonInstance.networktatus = JSLNetworkStatusReachableViaWiFi;
                        // 发送通知
                        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                        [notificationCenter postNotificationName:JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY
                                                          object:self
                                                        userInfo:@{JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_KEY:@(JSLNetworkStatusReachableViaWiFi)}];
                        break;
                    }
                    default: {
                        break;
                    }
                }
            }];
            [_singetonInstance.manager startMonitoring];
        }
    });
    return _singetonInstance;
}


+ (JSLNetworkStatus)currentNetworktatus
{
    return [JSLNetworkReachabilityUtil sharedNetworkUtilsWithCurrentReachabilityStatusBlock:nil].networktatus;
}

+ (BOOL)isNetworkAvailable
{
    switch ([JSLNetworkReachabilityUtil currentNetworktatus]) {
        case JSLNetworkStatusUnknown:
        case JSLNetworkStatusNotReachable: {
            return NO;
        }
        case JSLNetworkStatusReachableViaWWAN:
        case JSLNetworkStatusReachableViaWiFi: {
            return YES;
        }
    }
    return NO;
}


@end



