
#import "JSLDiaryManager.h"

@interface JSLDiaryManager()

@property (nonatomic, strong) JSLDiaryHandler *handler;

@end

@implementation JSLDiaryManager

+ (instancetype)sharedManager
{
    static JSLDiaryManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchDiaryInfosWithStartIndex:(NSInteger)startIndex
                           totalCount:(NSInteger)totalCount
                               result:(JSLResultBlock)resultBlock
{
    [self.handler fetchDiaryInfosWithStartIndex:startIndex
                                     totalCount:totalCount
                                         result:resultBlock];
}


- (void)cacheDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    [self.handler cacheDiaryInfo:diaryInfo result:resultBlock];
}


- (void)updateDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    [self.handler updateDiaryInfo:diaryInfo result:resultBlock];
}


- (void)deleteDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    [self.handler deleteDiaryInfo:diaryInfo result:resultBlock];
}


- (void)selectImageWithDiaryId:(NSInteger)diaryId result:(JSLResultBlock)resultBlock
{
    [self.handler selectImageWithDiaryId:diaryId result:resultBlock];
}


- (JSLDiaryHandler *)handler
{
    if (!_handler) {
        _handler = [[JSLDiaryHandler alloc] init];
    }
    
    return _handler;
}

@end
