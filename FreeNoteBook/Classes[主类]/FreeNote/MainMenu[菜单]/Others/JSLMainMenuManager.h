
#import <Foundation/Foundation.h>
#import "JSLMainMenuHandler.h"

@interface JSLMainMenuManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchHeadInfoWithResultBlock:(JSLResultBlock)resultBlock;

- (void)cacheHeadInfo:(JSLMainMenuHeadInfo *)headInfo;

- (void)fetchConfigInfoWithResultBlock:(JSLResultBlock)resultBlock;

- (void)cacheConfigInfo:(JSLAlertConfigInfo *)configInfo;

@end
