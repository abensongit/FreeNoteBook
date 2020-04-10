
#import "JSLAppUtil.h"

@implementation JSLAppUtil


#pragma mark -
#pragma mark 获取根视图控制器
+ (UIViewController *)getAppRootViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *rootViewController = window.rootViewController;
    return rootViewController;
}

#pragma mark 获取根顶部控制器
+ (UIViewController*)getTopViewController
{
    return [[self class] topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

#pragma mark 获取根顶部控制器 - 帮助
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [[self class] topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [[self class] topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [[self class] topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}



#pragma mark -
#pragma mark 获取应用版本信息
+ (NSString *)getAppVersion
{
    // 版本号数
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    // 正式版本
    return [NSString stringWithFormat:@"%@", version];
}


@end
