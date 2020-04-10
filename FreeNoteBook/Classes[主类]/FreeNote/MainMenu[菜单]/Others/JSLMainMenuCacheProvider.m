
#import "JSLMainMenuCacheProvider.h"

static NSString *homeHeadInfoKey = @"homeHeadInfoKey";
static NSString *alertNotifiHasClearKey = @"alertNotifiHasClearKey";

@implementation JSLMainMenuCacheProvider

- (JSLMainMenuHeadInfo *)queryHeadInfo
{
    return (JSLMainMenuHeadInfo *)[self.yyCache objectForKey:homeHeadInfoKey];
}


- (void)cacheHeadInfo:(JSLMainMenuHeadInfo *)headInfo
{
    [self.yyCache setObject:headInfo forKey:homeHeadInfoKey];
}


- (JSLAlertConfigInfo *)queryConfigInfo
{
    return (JSLAlertConfigInfo *)[self.yyCache objectForKey:alertNotifiHasClearKey];
}


- (void)cacheConfigInfo:(JSLAlertConfigInfo *)configInfo
{
    [self.yyCache setObject:configInfo forKey:alertNotifiHasClearKey];
}

@end
