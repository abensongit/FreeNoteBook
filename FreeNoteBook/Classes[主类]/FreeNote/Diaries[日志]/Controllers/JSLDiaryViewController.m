
#import "JSLDiaryViewController.h"
#import "JSLPublishDiaryViewController.h"
#import "JSLBaseNavigationController.h"
#import "JSLDiaryTableViewCell.h"
#import "JSLDiaryNoPicTableViewCell.h"
#import "JSLDiaryManager.h"
#import "UIView+JSLTips.h"
#import "MJRefresh.h"
#import "JSLDiaryShowViewController.h"
#import "JSLDiaryEditViewController.h"
#import "JSLMaskView.h"

@interface JSLDiaryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *diaryInfos;
@property (nonatomic, strong) JSLMaskView  *maskView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@end

static NSString *diaryTableViewCellIdentifier = @"diaryTableViewCellIdentifier";
static NSString *diaryNoPicTableViewCellIdentifier = @"diaryNoPicTableViewCellIdentifier";

@implementation JSLDiaryViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:diaryPublishSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPage)
                                                 name:diaryUpdateSuccessNotification
                                               object:nil];
    [self initUI];
    [self loadData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [_tableView registerClass:[JSLDiaryTableViewCell class]
           forCellReuseIdentifier:diaryTableViewCellIdentifier];
        [_tableView registerClass:[JSLDiaryNoPicTableViewCell class]
           forCellReuseIdentifier:diaryNoPicTableViewCellIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
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
    JSLPublishDiaryViewController *vc = [[JSLPublishDiaryViewController alloc] init];
    JSLBaseNavigationController *nav = [[JSLBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    self.title = STR_MAIN_MENU_ITEM_DIARIES;

    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = self.refreshFooter;
}


- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[JSLDiaryManager sharedManager] fetchDiaryInfosWithStartIndex:0 totalCount:10 result:^(JSLResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.diaryInfos = result.result;
        
        if (weakSelf.diaryInfos.count > 0) {
            [weakSelf.tableView reloadData];
            [weakSelf checkHasMore:result];
        } else {
            [weakSelf.maskView show];
            //
            [weakSelf checkHasMore:result];
        }
    }];
}


- (void)loadMoreData
{
    __weak typeof(self) weakSelf = self;
    [[JSLDiaryManager sharedManager] fetchDiaryInfosWithStartIndex:((JSLDiaryInfo *)self.diaryInfos.lastObject).diaryId totalCount:10 result:^(JSLResult *result) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.diaryInfos];
        [tmpArr addObjectsFromArray:result.result];
        weakSelf.diaryInfos = tmpArr;
        [weakSelf.tableView reloadData];
        [weakSelf checkHasMore:result];
    }];
}

- (void)checkHasMore:(JSLResult *)result
{
    [self setTableViewMJFooter];
    
    if (((NSArray *)result.result).count == 10) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)refreshList:(NSNotification *)notification
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.diaryInfos];
    [tmpArr insertObject:(JSLDiaryInfo *)notification.object atIndex:0];
    self.diaryInfos = tmpArr;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];//回到顶部
}

- (void)setTableViewMJFooter
{
    if (self.diaryInfos.count == 0) {
        [self.tableView setMj_footer:nil];
    } else {
        [self.tableView setMj_footer:self.refreshFooter];
    }
}

- (void)refreshPage
{
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.diaryInfos.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLDiaryInfo *info = self.diaryInfos[indexPath.row];
    if (info.diaryMiddleImage) {
        return 105;
    } else {
        return 75;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLDiaryInfo *info = self.diaryInfos[indexPath.row];
    if (info.diaryMiddleImage) {
        JSLDiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryTableViewCellIdentifier
                                                                     forIndexPath:indexPath];
        [cell updateCellWithDiaryInfo:info];
        return cell;
    } else {
        JSLDiaryNoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryNoPicTableViewCellIdentifier
                                               forIndexPath:indexPath];
        [cell updateCellWithDiaryInfo:info];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JSLDiaryShowViewController *vc = [[JSLDiaryShowViewController alloc] init];
    vc.diaryInfo = self.diaryInfos[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除这条记录吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView setEditing:NO];
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[JSLDiaryManager sharedManager] deleteDiaryInfo:(JSLDiaryInfo *)weakSelf.diaryInfos[indexPath.row] result:^{
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.diaryInfos];
            [tmpArr removeObjectAtIndex:indexPath.row];
            weakSelf.diaryInfos = tmpArr;
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

@end
