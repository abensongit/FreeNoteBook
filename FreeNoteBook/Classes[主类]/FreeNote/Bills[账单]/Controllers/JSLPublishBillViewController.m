
#import "JSLPublishBillViewController.h"
#import "JSLBillItemInfo.h"
#import "JSLPublishBillTableViewCell.h"
#import "JSLPublishBillEditTableViewCell.h"
#import "JSLDatePicker.h"
#import "JSLBillManager.h"
#import "UIView+JSLTips.h"
#import "MMNumberKeyboard.h"
#import "JSLBillTypePicker.h"
#import "JSLBillTypeInfo.h"
#import "JSLBillInfo.h"

@interface JSLPublishBillViewController ()<UITableViewDelegate, UITableViewDataSource, JSLDatePickerDelegate, MMNumberKeyboardDelegate, JSLBillTypePickerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *itemArr;
@property (nonatomic, strong) UITextField *countTextField;
@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) JSLDatePicker *datePicker;
@property (nonatomic, strong) NSDate       *date;
@property (nonatomic, strong) JSLBillTypePicker *typePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) MMNumberKeyboard *keyboard;

@end

static NSString *publishBillTableViewCellIdentifier = @"publishBillTableViewCellIdentifier";
static NSString *publishBillEditTableViewCellIdentifier = @"publishBillEditTableViewCellIdentifier";

@implementation JSLPublishBillViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (JSLNavBarButtonItemType)prefersNavigationBarLeftButtonItemType
{
    return JSLNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarLeftButtonItemTitle
{
    return STR_NAVIGATION_BAR_BUTTON_TITLE_CANCLE;
}

- (JSLNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return JSLNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarRightButtonItemTitle
{
    return STR_NAVIGATION_BAR_BUTTON_TITLE_SAVE;
}

- (UIColor *)prefersNavigationBarRightButtonItemTitleColorNormal
{
    return UIColorFromHexRGB(0x23A24D);
}

- (UIColor *)prefersNavigationBarRightButtonItemTitleColorSelect
{
    return UIColorFromHexRGB(0x23A24D);
}


#pragma mark - Private

- (void)initUI
{
    self.title = NSLocalizedString(@"记账", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(250);
    }];
    
    [self.view addSubview:self.tapView];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.mas_equalTo(250);
    }];
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSLPublishBillTableViewCell class]
           forCellReuseIdentifier:publishBillTableViewCellIdentifier];
        [_tableView registerClass:[JSLPublishBillEditTableViewCell class]
           forCellReuseIdentifier:publishBillEditTableViewCellIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    
    return _tableView;
}

- (UIView *)tapView
{
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
        _tapView.backgroundColor = [UIColor clearColor];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
        [_tapView addGestureRecognizer:gesture];
    }
    
    return _tapView;
}

- (JSLDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[JSLDatePicker alloc] init];
        _datePicker.delegate = self;
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    
    return _datePicker;
}

- (JSLBillTypePicker *)typePicker
{
    if (!_typePicker) {
        _typePicker = [[JSLBillTypePicker alloc] init];
        _typePicker.delegate = self;
    }

    return _typePicker;
}

- (NSArray *)itemArr
{
    if (!_itemArr) {
        JSLBillItemInfo *type = [[JSLBillItemInfo alloc] init];
        type.iconName = ICON_BILL_TYPE;
        type.itemName = NSLocalizedString(@"类型", nil);
        type.itemValue = NSLocalizedString(@"支出/吃", nil);
        
        JSLBillItemInfo *count = [[JSLBillItemInfo alloc] init];
        count.iconName = ICON_BILL_COUNT;
        count.itemValue = @"0.0";
        count.itemName = NSLocalizedString(@"金额", nil);
        
        JSLBillItemInfo *date = [[JSLBillItemInfo alloc] init];
        date.iconName = ICON_BILL_TIME;
        date.itemName = NSLocalizedString(@"时间", nil);
        NSDate *todayDate = [NSDate date];
        self.date = todayDate;
        NSString *time = [self.formatter stringFromDate:todayDate];
        date.itemValue = time;
        
        JSLBillItemInfo *remark = [[JSLBillItemInfo alloc] init];
        remark.iconName = ICON_BILL_REMARK;
        remark.itemName = NSLocalizedString(@"备注", nil);
        remark.itemValue = NSLocalizedString(@"备注", nil);
        _itemArr = @[type, count, date, remark];
    }
    
    return _itemArr;
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"MM/dd"];
    }
    
    return _formatter;
}

- (MMNumberKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        _keyboard.allowsDecimalPoint = YES;
        _keyboard.delegate = self;
    }
    
    return _keyboard;
}

#pragma mark - Action

- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    [self closeKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressNavigationBarRightButtonItem:(id)sender
{
    [self closeKeyBoard];
    
    if (self.countTextField.text.length == 0) {
        [JSLTips show:NSLocalizedString(@"请输入金额", nil)];
        return;
    }
    
    //构建bean 存入数据库
    JSLBillInfo *info = [[JSLBillInfo alloc] init];
    NSString *itemValue = ((JSLBillItemInfo *)self.itemArr[0]).itemValue;
    JSLBillType type = kJSLBillTypePayEat;
    if ([itemValue isEqualToString:NSLocalizedString(@"支出/吃", nil)]) {
        type = kJSLBillTypePayEat;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/穿", nil)]) {
        type = kJSLBillTypePayClothe;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/住", nil)]) {
        type = kJSLBillTypePayLive;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/行", nil)]) {
        type = kJSLBillTypePayWalk;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/玩", nil)]) {
        type = kJSLBillTypePayPlay;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/其他", nil)]) {
        type = kJSLBillTypePayOther;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/工资", nil)]) {
        type = kJSLBillTypeIncomeSalary;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/奖金", nil)]) {
        type = kJSLBillTypeIncomeAward;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/外快", nil)]) {
        type = kJSLBillTypeIncomeExtra;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/其他", nil)]) {
        type = kJSLBillTypeIncomeOther;
    }
    info.billType = type;
    info.billCount = self.countTextField.text.doubleValue;
    info.billDate = self.date;
    info.billRemark = self.remarkTextField.text;
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[JSLBillManager sharedManager] cacheBillInfo:info result:^{
        [weakSelf.view hideManualTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:billPublishSuccessNotification object:info];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)closeKeyBoard
{
    [self.countTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLBillItemInfo *itemInfo = self.itemArr[indexPath.row];
    if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"备注", nil)] || [itemInfo.itemName isEqualToString:NSLocalizedString(@"金额", nil)]) {
        JSLPublishBillEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBillEditTableViewCellIdentifier
                                                                               forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"备注", nil)]) {
            self.remarkTextField = cell.valueTextField;
        } else {
            self.countTextField = cell.valueTextField;
            self.countTextField.inputView = self.keyboard;
        }
        return cell;
    } else {
        JSLPublishBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBillTableViewCellIdentifier
                                                                           forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closeKeyBoard];
    if ([((JSLBillItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"类型", nil)]) {
        [self.typePicker show];
    } else if ([((JSLBillItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"时间", nil)]) {
        [self.datePicker show];
    }
}


#pragma mark - JSLDatePickerDelegate

- (void)changeTime:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;
    NSString *dateStr = [self.formatter stringFromDate:datePicker.date];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    JSLBillItemInfo *itemInfo = tmpArr[2];
    itemInfo.itemValue = dateStr;
    [tmpArr replaceObjectAtIndex:2 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}

#pragma mark - MMNumberKeyboardDelegate

- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text
{
    BOOL hasInputDot = NO;
    if (self.countTextField.text.length == 0) {
        return ![text isEqualToString:@"."];
    } else {
        if ([self.countTextField.text rangeOfString:@"."].location == NSNotFound) {
            if ([text isEqualToString:@"."]) {
                hasInputDot = YES;
                return YES;
            }
        } else {
            if ([text isEqualToString:@"."]) {
                return NO;
            } else {
               NSRange ran = [self.countTextField.text rangeOfString:@"."];
                return !(self.countTextField.text.length - ran.location > 2);
            }
        }
    }
    
    return YES;
}

#pragma mark - JSLBillTypePickerDelegate

- (void)pickerViewDidSelectType:(NSString *)type subType:(NSString *)subType
{
    NSString *typeStr = [NSString stringWithFormat:@"%@/%@", type, subType];
    JSLBillItemInfo *itemInfo = self.itemArr[0];
    itemInfo.itemValue = typeStr;
    [self.tableView reloadData];
}

@end
