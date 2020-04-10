
#import "JSLBaseLRUCacheProvider.h"
#import "JSLMainMenuHeadInfo.h"
#import "JSLAlertConfigInfo.h"

@interface JSLMainMenuCacheProvider : JSLBaseLRUCacheProvider

- (JSLMainMenuHeadInfo *)queryHeadInfo;

- (void)cacheHeadInfo:(JSLMainMenuHeadInfo *)headInfo;

- (JSLAlertConfigInfo *)queryConfigInfo;

- (void)cacheConfigInfo:(JSLAlertConfigInfo *)configInfo;

@end
