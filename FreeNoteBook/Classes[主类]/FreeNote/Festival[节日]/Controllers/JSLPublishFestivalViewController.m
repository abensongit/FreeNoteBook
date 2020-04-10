
#import "JSLPublishFestivalViewController.h"
#import "JSLFestivalItemInfo.h"
#import "JSLPublishFestivalTableViewCell.h"
#import "JSLPublishFestivalEditTableViewCell.h"
#import "CZPicker.h"
#import "JSLDatePicker.h"
#import "JSLFestivalManager.h"
#import "UIView+JSLTips.h"

@interface JSLPublishFestivalViewController () <UITableViewDelegate, UITableViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource, JSLDatePickerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *itemArr;
@property (nonatomic, strong) NSArray     *pickerItemArr;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) CZPickerView *picker;
@property (nonatomic, strong) JSLDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

static NSString *publishBigDayTableViewCellIdentifier = @"publishBigDayTableViewCellIdentifier";
static NSString *publishBigDayEditTableViewCellIdentifier = @"publishBigDayEditTableViewCellIdentifier";

@implementation JSLPublishFestivalViewController

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
    self.title = NSLocalizedString(@"记日子", nil);
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
        [_tableView registerClass:[JSLPublishFestivalTableViewCell class]
           forCellReuseIdentifier:publishBigDayTableViewCellIdentifier];
        [_tableView registerClass:[JSLPublishFestivalEditTableViewCell class]
           forCellReuseIdentifier:publishBigDayEditTableViewCellIdentifier];
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
        _picker = [[CZPickerView alloc] initWithHeaderTitle:NSLocalizedString(@"选择类型", nil)
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
    }
    
    return _datePicker;
}


- (NSArray *)itemArr
{
    if (!_itemArr) {
        JSLFestivalItemInfo *name = [[JSLFestivalItemInfo alloc] init];
        name.iconName = ICON_BILL_NAME;
        name.itemName = NSLocalizedString(@"名称", nil);
        JSLFestivalItemInfo *type = [[JSLFestivalItemInfo alloc] init];
        type.iconName = ICON_BILL_TYPE;
        type.itemName = NSLocalizedString(@"类型", nil);
        type.itemValue = NSLocalizedString(@"生日", nil);
        JSLFestivalItemInfo *date = [[JSLFestivalItemInfo alloc] init];
        date.iconName = ICON_BILL_TIME;
        date.itemName = NSLocalizedString(@"日期", nil);
        NSDate *todayDate = [NSDate date];
        NSString *time = [self.formatter stringFromDate:todayDate];
        date.itemValue = time;
        JSLFestivalItemInfo *remark = [[JSLFestivalItemInfo alloc] init];
        remark.iconName = ICON_BILL_REMARK;
        remark.itemName = NSLocalizedString(@"备注", nil);
        _itemArr = @[name, type, date, remark];
    }

    return _itemArr;
}


- (NSArray *)pickerItemArr
{
    return @[NSLocalizedString(@"生日", nil), NSLocalizedString(@"纪念日", nil), NSLocalizedString(@"其他", nil)];
}


- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"YYYY/MM/dd"];
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
        [JSLTips show:NSLocalizedString(@"请输入名称", nil)];
        return;
    }
    //构建bean 存入数据库
    
    JSLFestivalInfo *info = [[JSLFestivalInfo alloc] init];
    info.bigDayName = self.nameTextField.text;
    info.bigDayRemark = self.remarkTextField.text;
    info.bigDayType = ((JSLFestivalItemInfo *)self.itemArr[1]).itemValue;
    info.bigDayDate = ((JSLFestivalItemInfo *)self.itemArr[2]).itemValue;
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[JSLFestivalManager sharedManager] cacheBigDayInfo:info result:^{
        [weakSelf.view hideManualTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:festivalPublishSuccessNotification object:info];
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
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLFestivalItemInfo *itemInfo = self.itemArr[indexPath.row];
    if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"类型", nil)] || [itemInfo.itemName isEqualToString:NSLocalizedString(@"日期", nil)]) {
        JSLPublishFestivalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBigDayTableViewCellIdentifier
                                                                             forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        return cell;
    } else {
        JSLPublishFestivalEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBigDayEditTableViewCellIdentifier
                                                                                 forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"名称", nil)]) {
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
    if ([((JSLFestivalItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"类型", nil)]) {
        NSInteger selectedIndex = 0;
        JSLFestivalItemInfo *itemInfo = self.itemArr[1];
        for (NSInteger index = 0; index < self.pickerItemArr.count; index ++) {
            NSString *item = self.pickerItemArr[index];
            if ([itemInfo.itemValue isEqualToString:item]) {
                selectedIndex = index;
                break;
            }
        }
        [self.picker setSelectedRows:@[ [NSNumber numberWithInteger:selectedIndex] ]];
        [self.picker show];
    } else if ([((JSLFestivalItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"日期", nil)]) {
        [self.datePicker show];
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
    JSLFestivalItemInfo *itemInfo = tmpArr[1];
    itemInfo.itemValue = type;
    [tmpArr replaceObjectAtIndex:1 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}


#pragma mark - JSLDatePickerDelegate

- (void)changeTime:(UIDatePicker *)datePicker
{
    NSString *dateStr = [self.formatter stringFromDate:datePicker.date];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    JSLFestivalItemInfo *itemInfo = tmpArr[2];
    itemInfo.itemValue = dateStr;
    [tmpArr replaceObjectAtIndex:2 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}

@end
