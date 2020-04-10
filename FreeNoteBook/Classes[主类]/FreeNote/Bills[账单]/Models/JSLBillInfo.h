
#import "JSLAutoCoding.h"

typedef NS_ENUM(NSInteger, JSLBillType) {
    kJSLBillTypePayEat = 1,//支出 - 吃
    kJSLBillTypePayClothe, //支出 - 穿
    kJSLBillTypePayLive,   //支出 - 住
    kJSLBillTypePayWalk,   //支出 - 行
    kJSLBillTypePayPlay,   //支出 - 玩
    kJSLBillTypePayOther,  //支出 - 其他
    
    kJSLBillTypeIncomeSalary,  //收入 - 工资
    kJSLBillTypeIncomeAward,   //收入 - 奖金
    kJSLBillTypeIncomeExtra,   //收入 - 外快
    kJSLBillTypeIncomeOther,   //收入 - 其他
};


@interface JSLBillInfo : JSLAutoCoding

@property (nonatomic, assign) NSInteger  billId;
@property (nonatomic, assign) JSLBillType billType;               //账单类型
@property (nonatomic, assign) double     billCount;              //账单金额
@property (nonatomic, strong) NSDate     *billDate;              //账单日期
@property (nonatomic, copy)   NSString   *billRemark;            //账单备注

@end
