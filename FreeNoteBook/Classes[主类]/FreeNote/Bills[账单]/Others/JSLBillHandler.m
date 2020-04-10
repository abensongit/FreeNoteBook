
#import "JSLBillHandler.h"

@interface JSLBillHandler()

@property (nonatomic, strong) JSLBillCacheProvider *provider;

@end

@implementation JSLBillHandler

- (void)fetchBillInfosBeforeDate:(NSDate *)date
                      totalCount:(NSInteger)totalCount
                          result:(JSLResultBlock)resultBlock;
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<JSLBillInfo *> *billInfos = [weakSelf.provider selectBillInfosBeforeDate:date totalCount:totalCount];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = [weakSelf groupBillInfos:billInfos];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheBillInfo:billInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deleteBillInfo:(JSLBillInfo *)billInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deleteBillInfo:billInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)fetchMonthBillInMonth:(NSString *)month result:(JSLResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<JSLBillInfo *> *billInfos = [weakSelf.provider selectBillInfosBetween:[weakSelf startDateInMonth:month] and:[weakSelf endDateInMonth:month]];
        JSLBillMonthInfo *info = [weakSelf buildMonthBill:billInfos];
        JSLResult *result = [[JSLResult alloc] init];
        result.result = info;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}

#pragma mark - Getter

- (JSLBillCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[JSLBillCacheProvider alloc] init];
    }
    
    return _provider;
}


#pragma mark - Private

- (NSArray *)groupBillInfos:(NSArray *)billInfos
{
    NSMutableArray *resultArr = [NSMutableArray array];
    for (JSLBillInfo *info in billInfos) {
        if (resultArr.count == 0) {
            NSMutableArray *tmpArr = [NSMutableArray array];
            [tmpArr addObject:info];
            [resultArr addObject:tmpArr];
        } else {
            NSMutableArray *tmpAr = resultArr.lastObject;
            if (tmpAr.count > 0) {
                JSLBillInfo *lastInfo = tmpAr.lastObject;
                if ([self isMonth:info.billDate inMonth:lastInfo.billDate]) {
                    [tmpAr addObject:info];
                } else {
                    NSMutableArray *tmpArr = [NSMutableArray array];
                    [tmpArr addObject:info];
                    [resultArr addObject:tmpArr];
                }
            }
        }
    }

    return resultArr;
}


//判断两个时间是否是同一个月
- (BOOL)isMonth:(NSDate *)date1 inMonth:(NSDate *)date2
{
    if (nil == date1 || nil == date2) {
        return NO;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *date1Str = [formatter stringFromDate:date1];
    NSString *date2Str = [formatter stringFromDate:date2];
    return [date1Str isEqualToString:date2Str];
}


- (NSDate *)startDateInMonth:(NSString *)month
{
    if (month.length == 0) {
        return nil;
    }
    
    NSString *yearStr = [month substringWithRange:NSMakeRange(0, 4)];
    NSInteger yearInt = yearStr.integerValue;
    
    NSString *monthStr = [month substringWithRange:NSMakeRange(5, 2)];
    NSInteger monthInt = monthStr.integerValue;
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01 00:00:00", @(yearInt), @(monthInt)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-M-dd HH:mm:ss"];
    return [formatter dateFromString:dateStr];
}


- (NSDate *)endDateInMonth:(NSString *)month
{
    if (month.length == 0) {
        return nil;
    }
    
    NSString *yearStr = [month substringWithRange:NSMakeRange(0, 4)];
    NSInteger yearInt = yearStr.integerValue;
    
    NSString *monthStr = [month substringWithRange:NSMakeRange(5, 2)];
    NSInteger monthInt = monthStr.integerValue;
    
    NSInteger maxDay = 0;
    if (2 == monthInt) {
        if((yearInt % 4 == 0 && yearInt % 100 != 0) || yearInt % 400 == 0) {
            maxDay = 29;
        } else {
            maxDay = 28;
        }
    } else if (4 == monthInt || 6 == monthInt || 9 == monthInt || 11 == monthInt) {
        maxDay = 30;
    } else {
        maxDay = 31;
    }

    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ 23:59:59", @(yearInt), @(monthInt), @(maxDay)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-M-d HH:mm:ss"];
    return [formatter dateFromString:dateStr];
}


- (JSLBillMonthInfo *)buildMonthBill:(NSArray *)billInfos
{
    JSLBillMonthInfo *monthInfo = [[JSLBillMonthInfo alloc] init];
    
    for (JSLBillInfo *info in billInfos) {
        switch (info.billType) {
            case kJSLBillTypePayEat:
                monthInfo.eat += info.billCount;
                break;
            
            case kJSLBillTypePayClothe:
                monthInfo.clothe += info.billCount;
                break;
                
            case kJSLBillTypePayLive:
                monthInfo.live += info.billCount;
                break;
                
            case kJSLBillTypePayWalk:
                monthInfo.walk += info.billCount;
                break;
                
            case kJSLBillTypePayPlay:
                monthInfo.play += info.billCount;
                break;
                
            case kJSLBillTypePayOther:
                monthInfo.payOther += info.billCount;
                break;
                
            case kJSLBillTypeIncomeSalary:
                monthInfo.salary += info.billCount;
                break;
                
            case kJSLBillTypeIncomeAward:
                monthInfo.award += info.billCount;
                break;
                
            case kJSLBillTypeIncomeExtra:
                monthInfo.extra += info.billCount;
                break;
                
            case kJSLBillTypeIncomeOther:
                monthInfo.incomeOther += info.billCount;
                break;
            
            default:
                break;
        }
    }
    
    return monthInfo;
}

@end
