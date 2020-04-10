
#import "JSLBillViewController.h"
#import "JSLPublishBillViewController.h"
#import "JSLBaseNavigationController.h"
#import "JSLBillManager.h"
#import "JSLBillTableViewCell.h"
#import "JSLBillHeaderView.h"
#import "UIView+JSLTips.h"
#import "JSLMonthBillViewController.h"
#import "MJRefresh.h"
#import "JSLMaskView.h"

@interface JSLBillViewController ()<UITableViewDelegate, UITableViewDataSource, JSLBillHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *billInfos;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;
@property (nonatomic, strong) JSLMaskView  *maskView;

@end

static NSString *billTableViewCellIdentifier = @"billTableViewCellIdentifier";
static NSString *billTableViewHeaderIdentifier = @"billTableViewHeaderIdentifier";

@implementation JSLBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:billPublishSuccessNotification
                                               object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.title = STR_MAIN_MENU_ITEM_BILLS;
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = self.refreshFooter;
}


- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[JSLBillManager sharedManager] fetchBillInfosBeforeDate:nil totalCount:20 result:^(JSLResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.billInfos = result.result;
        if (weakSelf.billInfos.count > 0) {
            [weakSelf.tableView reloadData];
            [weakSelf checkHasMore:result];
        } else {
            [weakSelf.maskView show];
            //
            [weakSelf checkHasMore:result];
        }
        
        [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];//回到顶部
    }];
}


- (void)loadMoreData
{
    NSArray *arr = self.billInfos.lastObject;
    JSLBillInfo *billInfo = arr.lastObject;
    __weak typeof(self) weakSelf = self;
    [[JSLBillManager sharedManager] fetchBillInfosBeforeDate:billInfo.billDate totalCount:20 result:^(JSLResult *result) {
        [weakSelf addInfos:result];
        [weakSelf.tableView reloadData];
        [weakSelf checkHasMore:result];
    }];
}

- (void)setTableViewMJFooter
{
    if (self.billInfos.count == 0) {
        [self.tableView setMj_footer:nil];
    } else {
        [self.tableView setMj_footer:self.refreshFooter];
    }
}

- (void)checkHasMore:(JSLResult *)result
{
    [self setTableViewMJFooter];
    
    NSInteger totalCount = 0;
    for (NSArray *arr in result.result) {
        totalCount += arr.count;
    }
    
    if (totalCount == 20) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)addInfos:(JSLResult *)result
{
    if (((NSArray *)result.result).count == 0) {
        return;
    }
    
    NSArray *arr = self.billInfos.lastObject;
    JSLBillInfo *info = arr.lastObject;
    
    NSArray *newArr = ((NSArray *)result.result).firstObject;
    JSLBillInfo *newInfo = newArr.firstObject;
    if ([self isMonth:info.billDate inMonth:newInfo.billDate]) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.billInfos.lastObject];
        for (JSLBillInfo *info in newArr) {
            [arr addObject:info];
        }
        NSMutableArray *tmpBillInfos = [NSMutableArray arrayWithArray:self.billInfos];
        [tmpBillInfos removeLastObject];
        [tmpBillInfos addObject:arr];
        
        for (NSInteger i = 1; i < ((NSArray *)result.result).count; i++) {
            [tmpBillInfos addObject:((NSArray *)result.result)[i]];
        }
        
        self.billInfos = tmpBillInfos;
        
    } else {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.billInfos];
        for (NSArray *arr in (NSArray *)result.result) {
            [tmpArr addObject:arr];
        }
        self.billInfos = tmpArr;
    }
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

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[JSLBillTableViewCell class]
           forCellReuseIdentifier:billTableViewCellIdentifier];
        [_tableView registerClass:[JSLBillHeaderView class]
forHeaderFooterViewReuseIdentifier:billTableViewHeaderIdentifier];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"YYYY/MM"];
    }

    return _formatter;
}


- (MJRefreshAutoNormalFooter *)refreshFooter
{
    if (!_refreshFooter) {
        __weak typeof(self) weakSelf = self;
        _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        [_refreshFooter setTitle:NSLocalizedString(@"点击或上拉加载更多", nil) forState:MJRefreshStateIdle];
        [_refreshFooter setTitle:NSLocalizedString(@"正在玩命加载...", nil) forState:MJRefreshStateRefreshing];
        [_refreshFooter setTitle:NSLocalizedString(@"没有更多了", nil) forState:MJRefreshStateNoMoreData];
        _refreshFooter.stateLabel.font = [UIFont systemFontOfSize:15];
        _refreshFooter.stateLabel.textColor = UIColorFromHexRGB(0x999999);
        [_refreshFooter setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    
    return _refreshFooter;
}


- (JSLMaskView *)maskView
{
    if (!_maskView) {
        _maskView = [[JSLMaskView alloc] init];
    }

    return _maskView;
}

#pragma mark - Action

- (void)pressNavigationBarRightButtonItem:(id)sender
{
    JSLPublishBillViewController *vc = [[JSLPublishBillViewController alloc] init];
    JSLBaseNavigationController *nav = [[JSLBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (JSLNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return JSLNavBarButtonItemTypeCustom;
}

- (UIView *)createNavigationBarButtonItemTypeCustomTitle:(NSString *)title
                                        titleNormalColor:(UIColor *)normalColor
                                        titleSelectColor:(UIColor *)selectColor
                                               titleFont:(UIFont *)font
                                          iconNameNormal:(NSString *)iconNameNormal
                                          iconNameSelect:(NSString *)iconNameSelect
                                                  action:(SEL)action
{
    // 自定义按钮
    CGFloat imageSizeWith = JSL_AUTOSIZING_WIDTH(22.0f);
    CGFloat imageSizeHeight = JSL_AUTOSIZING_WIDTH(22.0f);
    CGRect btnFrame = CGRectMake(0, 0, NAVIGATION_BAR_BUTTON_MAX_WIDTH, NAVIGATION_BAR_HEIGHT);
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [btn setImage:[[UIImage imageNamed:iconNameNormal] imageByScalingProportionallyToSize:CGSizeMake(imageSizeWith, imageSizeHeight)]
         forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageNamed:iconNameSelect] imageByScalingProportionallyToSize:CGSizeMake(imageSizeWith, imageSizeHeight)]
         forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (NSString *)prefersNavigationBarRightButtonItemImageNormal
{
    return ICON_PLUS_SYSBOL;
}

- (NSString *)prefersNavigationBarRightButtonItemImageSelect
{
    return ICON_PLUS_SYSBOL;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.billInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.billInfos[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *infoArr = self.billInfos[indexPath.section];
    JSLBillInfo *info = infoArr[indexPath.row];
    JSLBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:billTableViewCellIdentifier
                                    forIndexPath:indexPath];
    [cell updateCellWithBillInfo:info];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JSLBillHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:billTableViewHeaderIdentifier];
    NSArray *infoArr = self.billInfos[section];
    JSLBillInfo *info = infoArr.firstObject;
    NSString *month = [self.formatter stringFromDate:info.billDate];
    [view updateViewWithTitle:month];
    view.delegate = self;
    return view;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除这条记录吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView setEditing:NO];
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *infos = weakSelf.billInfos[indexPath.section];
        JSLBillInfo *billInfo = infos[indexPath.row];
        [[JSLBillManager sharedManager] deleteBillInfo:billInfo result:^{
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.billInfos[indexPath.section]];
            [tmpArr removeObjectAtIndex:indexPath.row];
            NSMutableArray *billInfosTmp = [NSMutableArray arrayWithArray:weakSelf.billInfos];
            [billInfosTmp replaceObjectAtIndex:indexPath.section withObject:tmpArr];
            weakSelf.billInfos = billInfosTmp;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirmAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", nil);
}


#pragma mark - JSLBillHeaderViewDelegate

- (void)enterMonthBillWithMonth:(NSString *)month
{
    JSLMonthBillViewController *vc = [[JSLMonthBillViewController alloc] init];
    vc.monthStr = month;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
