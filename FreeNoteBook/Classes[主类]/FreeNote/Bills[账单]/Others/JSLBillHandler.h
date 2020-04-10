
#import "JSLBaseHandler.h"
#import "JSLBillCacheProvider.h"
#import "JSLBillMonthInfo.h"

@interface JSLBillHandler : JSLBaseHandler

- (void)fetchBillInfosBeforeDate:(NSDate *)date
                      totalCount:(NSInteger)totalCount
                          result:(JSLResultBlock)resultBlock;

- (void)cacheBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock;

- (void)deleteBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock;

- (void)fetchMonthBillInMonth:(NSString *)month result:(JSLResultBlock)resultBlock;

@end
