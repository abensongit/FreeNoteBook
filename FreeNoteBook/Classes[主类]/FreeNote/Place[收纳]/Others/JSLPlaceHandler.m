
#import "JSLPlaceHandler.h"

@interface JSLPlaceHandler()

@property (nonatomic, strong) JSLPlaceCacheProvider *provider;

@end

@implementation JSLPlaceHandler

- (void)fetchPlaceInfosWithStartIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount result:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<JSLPlaceInfo *> *placeInfos = [weakSelf.provider selectPlaceInfosFromStart:startIndex
                                                                               totalCount:totalCount];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = placeInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cachePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cachePlaceInfo:placeInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deletePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deletePlaceInfo:placeInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


#pragma mark - Getter

- (JSLPlaceCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[JSLPlaceCacheProvider alloc] init];
    }
    
    return _provider;
}

@end
