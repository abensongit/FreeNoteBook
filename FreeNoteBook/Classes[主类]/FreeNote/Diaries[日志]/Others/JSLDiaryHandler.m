
#import "JSLDiaryHandler.h"

@interface JSLDiaryHandler()

@property (nonatomic, strong) JSLDiaryCacheProvider *provider;

@end

@implementation JSLDiaryHandler

- (void)fetchDiaryInfosWithStartIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount result:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<JSLDiaryInfo *> *diaryInfos = [weakSelf.provider selectDiaryInfosFromStart:startIndex
                                                                               totalCount:totalCount];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = diaryInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheDiaryInfo:diaryInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateDiaryInfo:diaryInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deleteDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deleteDiaryInfo:diaryInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)selectImageWithDiaryId:(NSInteger)diaryId result:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        UIImage *img = [weakSelf.provider selectImageWithDiaryId:diaryId];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = img;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}

#pragma mark - Getter

- (JSLDiaryCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[JSLDiaryCacheProvider alloc] init];
    }
    
    return _provider;
}

@end
