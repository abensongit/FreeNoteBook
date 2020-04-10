
#import "JSLDeviceUtil.h"

@implementation JSLDeviceUtil

+ (instancetype)sharedDevice
{
    static JSLDeviceUtil *_util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _util = [[self alloc] init];
    });

    return _util;
}


- (NSString *)appName
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    return [appName copy];
}


- (NSString *)appVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return [appVersion copy];
}


- (NSString *)appBuildVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return [appBuildVersion copy];
}


- (UIImage *)appIcon
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appIconStr = [[infoDic valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    appIconStr = ICON_APPLICAON_LOGO;
    return [UIImage imageNamed:appIconStr];
}

@end
