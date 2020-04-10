
#import "JSLBaseHandler.h"
#import "JSLMainMenuCacheProvider.h"

@interface JSLMainMenuHandler : JSLBaseHandler

- (void)fetchHeadInfoWithResultBlock:(JSLResultBlock)resultBlock;

- (void)cacheHeadInfo:(JSLMainMenuHeadInfo *)headInfo;

- (void)fetchConfigInfoWithResultBlock:(JSLResultBlock)resultBlock;

- (void)cacheConfigInfo:(JSLAlertConfigInfo *)configInfo;

@end
