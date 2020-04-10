
#import "JSLBaseDatabaseCommonProvider.h"
#import "JSLBillInfo.h"

@interface JSLBillCacheProvider : JSLBaseDatabaseCommonProvider

- (NSArray<JSLBillInfo *> *)selectBillInfosBeforeDate:(NSDate *)date
                                          totalCount:(NSInteger)totalCount;

- (void)cacheBillInfo:(JSLBillInfo *)BillInfo;

- (void)deleteBillInfo:(JSLBillInfo *)BillInfo;


- (NSArray<JSLBillInfo *> *)selectBillInfosBetween:(NSDate *)fromDate and:(NSDate *)toDate;

@end
