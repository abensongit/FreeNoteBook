
#import "JSLAlertHandler.h"

@interface JSLAlertHandler()

@property (nonatomic, strong) JSLAlertCacheProvider *provider;

@end

@implementation JSLAlertHandler

- (void)fetchAlertInfosWithResult:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<JSLAlertInfo *> *alertInfos = [weakSelf.provider selectAlertInfos];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = [weakSelf groupAlertInfos:alertInfos];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)fetchUnJoinedAlertInfosWithResult:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<JSLAlertInfo *> *alertInfos = [weakSelf.provider selectUnJoinedAlertInfos];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = alertInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)selectAlertInfoWithAlertId:(NSInteger)alertId result:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        JSLAlertInfo *alertInfo = [weakSelf.provider selectAlertInfoWithAlertId:alertId];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = alertInfo;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheAlertInfo:alertInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateAlertIsJoined:(BOOL)isJoined alertId:(NSInteger)alertId result:(void (^)(void))resultBlock;
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateAlertIsjoined:isJoined alertId:alertId];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateAlertIsFinishedwithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateAlertIsFinishedWithAlertId:alertId];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateAlertIsCompleteWithAlertId:alertId];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deleteAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deleteAlertInfo:alertInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)autoCheckToMarkFinish
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider autoCheckToMarkFinish];
    });
}

#pragma mark - Private

- (NSArray *)groupAlertInfos:(NSArray *)alertInfos
{
    NSMutableArray *goingOnInfos = [NSMutableArray array];
    NSMutableArray *finishedInfos = [NSMutableArray array];
    NSMutableArray *completeInfos = [NSMutableArray array];
    for (JSLAlertInfo *info in alertInfos) {
        if (info.isFinish) {
            if (info.isComplete) {
                [completeInfos addObject:info];
            } else {
                [finishedInfos addObject:info];
            }
        } else {
            [goingOnInfos addObject:info];
        }
    }

    return @[goingOnInfos, finishedInfos, completeInfos];
}

#pragma mark - Getter

- (JSLAlertCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[JSLAlertCacheProvider alloc] init];
    }
    
    return _provider;
}

@end
