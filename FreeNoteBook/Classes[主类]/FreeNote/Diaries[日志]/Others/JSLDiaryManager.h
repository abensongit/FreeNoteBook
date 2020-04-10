
#import <Foundation/Foundation.h>
#import "JSLDiaryHandler.h"

@interface JSLDiaryManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchDiaryInfosWithStartIndex:(NSInteger)startIndex
                           totalCount:(NSInteger)totalCount
                               result:(JSLResultBlock)resultBlock;

- (void)cacheDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock;

- (void)updateDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock;

- (void)deleteDiaryInfo:(JSLDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock;

- (void)selectImageWithDiaryId:(NSInteger)diaryId result:(JSLResultBlock)resultBlock;

@end
