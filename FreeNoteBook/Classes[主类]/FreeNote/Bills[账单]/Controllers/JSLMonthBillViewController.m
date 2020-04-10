
#import "JSLMonthBillViewController.h"
#import "JSLMonthBillTableViewCell.h"
#import "JSLBillManager.h"
#import "UIView+JSLTips.h"

@interface JSLMonthBillViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JSLBillMonthInfo *monthInfo;

@end

static NSString *monthBillTableViewCellIdentifier = @"monthBillTableViewCellIdentifier";
static NSString *monthBillTableViewHeaderIdentifier = @"monthBillTableViewHeaderIdentifier";

@implementation JSLMonthBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    self.title = NSLocalizedString(@"月账单", nil);
    [self.view addSubview:self.tableView];
}

- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[JSLBillManager sharedManager] fetchMonthBillInMonth:self.monthStr result:^(JSLResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.monthInfo = result.result;
        [weakSelf.tableView reloadData];
    }];
}

- (CGFloat)cellHeight
{
    if (IS_3_5_INCH || IS_4_0_INCH) {
        return 300;
    } else if (IS_4_7_INCH) {
        return 340;
    } else {
        return 360;
    }
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
        [_tableView registerClass:[JSLMonthBillTableViewCell class] forCellReuseIdentifier:monthBillTableViewCellIdentifier];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:monthBillTableViewHeaderIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLMonthBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:monthBillTableViewCellIdentifier
                                                                forIndexPath:indexPath];
    NSString *type = nil;
    if (indexPath.row == 0) {
        type = NSLocalizedString(@"总支出", nil);
    } else {
        type = NSLocalizedString(@"总收入", nil);
    }
    
    [cell updateCellWithTitle:type monthInfo:self.monthInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:monthBillTableViewHeaderIdentifier];
    headerView.contentView.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:monthBillTableViewHeaderIdentifier];
    footerView.contentView.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    return footerView;
}

@end

