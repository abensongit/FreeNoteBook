
#import "JSLNavBarViewController.h"
@class JSLNetworkViewController;

@protocol JSLNetworkViewControllerProtocol <NSObject>
@optional
- (void)currentNetworkReachabilityStatus:(JSLNetworkStatus)currentNetworkStatus inViewController:(JSLNetworkViewController *)inViewController;
@end

@interface JSLNetworkViewController : JSLNavBarViewController <JSLNetworkViewControllerProtocol>

#pragma mark 监听网络变化后执行 - 有网络
- (void)viewDidLoadWithNetworkingStatus;

#pragma mark 监听网络变化后执行 - 无网络
- (void)viewDidLoadWithNoNetworkingStatus;

@end

