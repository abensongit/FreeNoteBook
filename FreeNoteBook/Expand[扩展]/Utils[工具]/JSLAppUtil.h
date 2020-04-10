
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLAppUtil : NSObject

#pragma mark -
#pragma mark 获取根视图控制器
+ (UIViewController *)getAppRootViewController;
#pragma mark 获取根顶部控制器
+ (UIViewController*)getTopViewController;


#pragma mark -
#pragma mark 获取应用版本信息
+ (NSString *)getAppVersion;

@end

NS_ASSUME_NONNULL_END
