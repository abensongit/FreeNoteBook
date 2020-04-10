
#import "JSLBillManager.h"

@interface JSLBillManager()

@property (nonatomic, strong) JSLBillHandler *handler;

@end

@implementation JSLBillManager

+ (instancetype)sharedManager
{
    static JSLBillManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchBillInfosBeforeDate:(NSDate *)date
                      totalCount:(NSInteger)totalCount
                          result:(JSLResultBlock)resultBlock
{
    [self.handler fetchBillInfosBeforeDate:date
                                totalCount:totalCount
                                    result:resultBlock];
}


- (void)cacheBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock
{
    [self.handler cacheBillInfo:billInfo result:resultBlock];
}


- (void)deleteBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock
{
    [self.handler deleteBillInfo:billInfo result:resultBlock];
}


- (void)fetchMonthBillInMonth:(NSString *)month result:(JSLResultBlock)resultBlock
{
    [self.handler fetchMonthBillInMonth:month result:resultBlock];
}


- (JSLBillHandler *)handler
{
    if (!_handler) {
        _handler = [[JSLBillHandler alloc] init];
    }
    
    return _handler;
}

@end
