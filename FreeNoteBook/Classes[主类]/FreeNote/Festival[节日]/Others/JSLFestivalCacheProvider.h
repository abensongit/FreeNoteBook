
#import "JSLBaseDatabaseCommonProvider.h"
#import "JSLFestivalInfo.h"

@interface JSLFestivalCacheProvider : JSLBaseDatabaseCommonProvider

- (NSArray<JSLFestivalInfo *> *)selectBigDayInfosFromStart:(NSInteger)startIndex
                                             totalCount:(NSInteger)totalCount;

- (void)cacheBigDayInfo:(JSLFestivalInfo *)bigDayInfo;

- (void)deleteBigDayInfo:(JSLFestivalInfo *)bigDayInfo;

@end
