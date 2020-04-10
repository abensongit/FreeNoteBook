
#import <Foundation/Foundation.h>
#import "JSLFestivalHandler.h"

@interface JSLFestivalManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchBigDayInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(JSLResultBlock)resultBlock;

- (void)cacheBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock;

- (void)deleteBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock;

@end
