
#import <Foundation/Foundation.h>
#import "JSLBillHandler.h"

@interface JSLBillManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchBillInfosBeforeDate:(NSDate *)date
                      totalCount:(NSInteger)totalCount
                          result:(JSLResultBlock)resultBlock;

- (void)cacheBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock;

- (void)deleteBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock;

- (void)fetchMonthBillInMonth:(NSString *)month result:(JSLResultBlock)resultBlock;

@end
