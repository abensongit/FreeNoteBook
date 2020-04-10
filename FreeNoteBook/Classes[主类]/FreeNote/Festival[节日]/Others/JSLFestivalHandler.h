
#import "JSLBaseHandler.h"
#import "JSLFestivalCacheProvider.h"

@interface JSLFestivalHandler : JSLBaseHandler

- (void)fetchBigDayInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(JSLResultBlock)resultBlock;

- (void)cacheBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock;

- (void)deleteBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock;

@end
