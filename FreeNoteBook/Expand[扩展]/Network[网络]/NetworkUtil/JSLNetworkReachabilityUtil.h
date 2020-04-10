

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark 网络可达状态
typedef NS_ENUM(NSUInteger, JSLNetworkStatus) {
    /** 未知网络 */
    JSLNetworkStatusUnknown,
    /** 不可达的网络(未连接) */
    JSLNetworkStatusNotReachable,
    /** 手机网络2G,3G,4G */
    JSLNetworkStatusReachableViaWWAN,
    /** WIFI网络 */
    JSLNetworkStatusReachableViaWiFi
};


#pragma mark -
#pragma mark 监听网络状态变动的广播通知频段
UIKIT_EXTERN NSString * const JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_FREQUENCY;
#pragma mark 监听网络状态变动的广播通知内容 - 字典KEY
UIKIT_EXTERN NSString * const JSL_NOTIFICATION_NETWORKING_REACHABILITY_STATUS_KEY;


#pragma mark -
#pragma mark 网络状态监听的广播通知频段
typedef void(^JSLCurrentReachabilityStatusBlock)(JSLNetworkStatus networkStatus);


@interface JSLNetworkReachabilityUtil : NSObject

+ (instancetype)sharedNetworkUtilsWithCurrentReachabilityStatusBlock:(JSLCurrentReachabilityStatusBlock)currentReachabilityStatusBlock;

+ (JSLNetworkStatus)currentNetworktatus;

+ (BOOL)isNetworkAvailable;

@end

