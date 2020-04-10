
#import "JSLPublishAlertViewController.h"
#import "JSLPublishAlertTableViewCell.h"
#import "JSLPublishAlertEditTableViewCell.h"
#import "JSLAlertItemInfo.h"
#import "CZPicker.h"
#import "JSLDatePicker.h"
#import "JSLAlertManager.h"
#import "UIView+JSLTips.h"

@interface JSLPublishAlertViewController () <UITableViewDelegate, UITableViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource, JSLDatePickerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *itemArr;
@property (nonatomic, strong) NSArray     *pickerItemArr;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) CZPickerView *picker;
@property (nonatomic, strong) JSLDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDate          *alertDate;

@end

static NSString *publishAlertTableViewCellIdentifier = @"publishAlertTableViewCellIdentifier";
static NSString *publishAlertEditTableViewCellIdentifier = @"publishAlertEditTableViewCellIdentifier";

@implementation JSLPublishAlertViewController

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
    self.title = NSLocalizedString(@"添加提醒", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    CGFloat itemHeight = JSL_AUTOSIZING_WIDTH_SCALE(50.0f);
    CGFloat tableHeight  = itemHeight * 5.0f;
    
    __weak __typeof(&*self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(tableHeight);
    }];
    
    [self.view addSubview:self.tapView];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.mas_equalTo(tableHeight);
    }];
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat itemHeight = JSL_AUTOSIZING_WIDTH_SCALE(50.0f);
        CGFloat tableHeight  = itemHeight * 5.0f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, tableHeight)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSLPublishAlertTableViewCell class]
           forCellReuseIdentifier:publishAlertTableViewCellIdentifier];
        [_tableView registerClass:[JSLPublishAlertEditTableViewCell class]
           forCellReuseIdentifier:publishAlertEditTableViewCellIdentifier];
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

- (CZPickerView *)picker
{
    if (!_picker) {
        _picker = [[CZPickerView alloc] initWithHeaderTitle:NSLocalizedString(@"选择重复模式", nil)
                                          cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                         confirmButtonTitle:NSLocalizedString(@"确定", nil)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.needFooterView = YES;
        _picker.headerBackgroundColor = UIColorFromHexRGB(0x1AAB19);
        _picker.confirmButtonBackgroundColor = UIColorFromHexRGB(0x1AAB19);
    }
    
    return _picker;
}

- (JSLDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[JSLDatePicker alloc] init];
        _datePicker.delegate = self;
        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    
    return _datePicker;
}


- (NSArray *)itemArr
{
    if (!_itemArr) {
        JSLAlertItemInfo *name = [[JSLAlertItemInfo alloc] init];
        name.itemName = NSLocalizedString(@"我想", nil);
        name.iconName = ICON_BILL_PLAN;
        JSLAlertItemInfo *type = [[JSLAlertItemInfo alloc] init];
        type.itemName = NSLocalizedString(@"重复", nil);
        type.itemValue = NSLocalizedString(@"从不", nil);
        type.iconName = ICON_BILL_MODE;
        JSLAlertItemInfo *date = [[JSLAlertItemInfo alloc] init];
        date.iconName = ICON_BILL_TIME;
        date.itemName = NSLocalizedString(@"时间", nil);
        NSDate *todayDate = [NSDate date];
        NSString *time = [self.formatter stringFromDate:todayDate];
        date.itemValue = time;
        self.alertDate = todayDate;
        JSLAlertItemInfo *remark = [[JSLAlertItemInfo alloc] init];
        remark.iconName = ICON_BILL_REMARK;
        remark.itemName = NSLocalizedString(@"备注", nil);
        _itemArr = @[name, type, date, remark];
    }
    
    return _itemArr;
}

- (NSArray *)pickerItemArr
{
    return @[ NSLocalizedString(@"从不", nil), NSLocalizedString(@"每天", nil), NSLocalizedString(@"每周", nil), NSLocalizedString(@"每月", nil) ];
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"MM/dd HH:mm"];
    }
    
    return _formatter;
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
    
    if (self.nameTextField.text.length == 0) {
        [JSLTips show:NSLocalizedString(@"请输入提醒名称", nil)];
        return;
    }
    
    // 构建bean 存入数据库
    JSLAlertInfo *info = [[JSLAlertInfo alloc] init];
    info.alertName = self.nameTextField.text;
    info.alertRemark = self.remarkTextField.text;
    NSString *itemValue = ((JSLAlertItemInfo *)self.itemArr[1]).itemValue;
    JSLAlertRepeatType type = kJSLAlertRepeatTypeNever;
    if ([itemValue isEqualToString:NSLocalizedString(@"从不", nil)]) {
        type = kJSLAlertRepeatTypeNever;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"每天", nil)]) {
        type = kJSLAlertRepeatTypeDay;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"每周", nil)]) {
        type = kJSLAlertRepeatTypeWeekday;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"每月", nil)]) {
        type = kJSLAlertRepeatTypeMonth;
    }
    
    info.alertRepeatType = type;
    info.alertDate = self.alertDate ? self.alertDate : [NSDate date];
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    
    __weak typeof(self) weakSelf = self;
    [[JSLAlertManager sharedManager] cacheAlertInfo:info result:^{
        [weakSelf.view hideManualTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:alertPublishSuccessNotification object:info];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)closeKeyBoard
{
    [self.nameTextField resignFirstResponder];
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
    return JSL_AUTOSIZING_WIDTH_SCALE(50.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLAlertItemInfo *itemInfo = self.itemArr[indexPath.row];
    if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"重复", nil)]
        || [itemInfo.itemName isEqualToString:NSLocalizedString(@"时间", nil)]) {
        JSLPublishAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishAlertTableViewCellIdentifier
                                                                             forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        return cell;
    } else {
        JSLPublishAlertEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishAlertEditTableViewCellIdentifier
                                                                                 forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"我想", nil)]) {
            self.nameTextField = cell.valueTextField;
        } else {
            self.remarkTextField = cell.valueTextField;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self closeKeyBoard];
    
    if ([((JSLAlertItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"重复", nil)]) {
        NSInteger selectedIndex = 0;
        JSLAlertItemInfo *itemInfo = self.itemArr[1];
        for (NSInteger index = 0; index < self.pickerItemArr.count; index ++) {
            NSString *item = self.pickerItemArr[index];
            if ([itemInfo.itemValue isEqualToString:item]) {
                selectedIndex = index;
                break;
            }
        }
        [self.picker setSelectedRows:@[ [NSNumber numberWithInteger:selectedIndex] ]];
        [self.picker show];
    } else if ([((JSLAlertItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"时间", nil)]) {
        [self.datePicker show];
        [self.datePicker setMinimumDate:[NSDate date]];
    }
}


#pragma mark - CZPickerView

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return self.pickerItemArr.count;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row
{
    return self.pickerItemArr[row];
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    NSString *type = self.pickerItemArr[row];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    JSLAlertItemInfo *itemInfo = tmpArr[1];
    itemInfo.itemValue = type;
    [tmpArr replaceObjectAtIndex:1 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}


#pragma mark - JSLDatePickerDelegate

- (void)changeTime:(UIDatePicker *)datePicker
{
    self.alertDate = datePicker.date;
    NSString *dateStr = [self.formatter stringFromDate:datePicker.date];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    JSLAlertItemInfo *itemInfo = tmpArr[2];
    itemInfo.itemValue = dateStr;
    [tmpArr replaceObjectAtIndex:2 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}


@end
