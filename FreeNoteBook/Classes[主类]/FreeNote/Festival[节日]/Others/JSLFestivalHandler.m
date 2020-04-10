
#import "JSLFestivalHandler.h"

@interface JSLFestivalHandler()

@property (nonatomic, strong) JSLFestivalCacheProvider *provider;

@end

@implementation JSLFestivalHandler

- (void)fetchBigDayInfosWithStartIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount result:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<JSLFestivalInfo *> *dayInfos = [weakSelf.provider selectBigDayInfosFromStart:startIndex
                                                                               totalCount:totalCount];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = dayInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheBigDayInfo:bigDayInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deleteBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deleteBigDayInfo:bigDayInfo];
        
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

- (JSLFestivalCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[JSLFestivalCacheProvider alloc] init];
    }
    
    return _provider;
}

@end
