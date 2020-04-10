
#import "JSLMainMenuHandler.h"

@interface JSLMainMenuHandler()

@property (nonatomic, strong) JSLMainMenuCacheProvider *provider;

@end

@implementation JSLMainMenuHandler

- (void)fetchHeadInfoWithResultBlock:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        JSLMainMenuHeadInfo *headInfo = [weakSelf.provider queryHeadInfo];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = headInfo;
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheHeadInfo:(JSLMainMenuHeadInfo *)headInfo
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheHeadInfo:headInfo];
    });
}


- (void)fetchConfigInfoWithResultBlock:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        JSLAlertConfigInfo *configInfo = [weakSelf.provider queryConfigInfo];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = configInfo;
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheConfigInfo:(JSLAlertConfigInfo *)configInfo
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheConfigInfo:configInfo];
    });
}

#pragma mark - Getter

- (JSLMainMenuCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[JSLMainMenuCacheProvider alloc] initWithName:@"FreeNoteBook_MainMenuProvider"];
    }

    return _provider;
}

@end
