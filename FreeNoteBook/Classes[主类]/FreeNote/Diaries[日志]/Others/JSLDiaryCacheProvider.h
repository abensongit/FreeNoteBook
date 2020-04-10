
#import "JSLBaseDatabaseCommonProvider.h"
#import "JSLDiaryInfo.h"

@interface JSLDiaryCacheProvider : JSLBaseDatabaseCommonProvider

- (NSArray<JSLDiaryInfo *> *)selectDiaryInfosFromStart:(NSInteger)startIndex
                                           totalCount:(NSInteger)totalCount;

- (void)cacheDiaryInfo:(JSLDiaryInfo *)diaryInfo;

- (void)updateDiaryInfo:(JSLDiaryInfo *)diaryInfo;

- (void)deleteDiaryInfo:(JSLDiaryInfo *)diaryInfo;

- (UIImage *)selectImageWithDiaryId:(NSInteger)diaryId;

@end
