
#import "JSLFestivalViewController.h"
#import "JSLBaseNavigationController.h"
#import "JSLPublishFestivalViewController.h"
#import "JSLFestivalManager.h"
#import "JSLFestivalCollectionViewLayout.h"
#import "JSLFestivalCollectionViewCell.h"
#import "UIView+JSLTips.h"
#import "MJRefresh.h"
#import "JSLMaskView.h"

@interface JSLFestivalViewController ()<JSLFestivalCollectionViewLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource, JSLFestivalCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray  *dayInfos;
@property (nonatomic, strong) NSIndexPath *editingIndexPath;//当前正在编辑的cell
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;
@property (nonatomic, strong) JSLMaskView  *maskView;

@end

static NSString *festivalCollectionViewCellIdentifier = @"festivalCollectionViewCellIdentifier";

@implementation JSLFestivalViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:festivalPublishSuccessNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    self.title = STR_MAIN_MENU_ITEM_FESTIVAL;

    [self.view addSubview:self.collectionView];
    self.collectionView.mj_footer = self.refreshFooter;
}


- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    [[JSLFestivalManager sharedManager] fetchBigDayInfosWithStartIndex:0 totalCount:20 result:^(JSLResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.dayInfos = result.result;
        if (weakSelf.dayInfos.count > 0) {
            [weakSelf.collectionView reloadData];
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
    [[JSLFestivalManager sharedManager] fetchBigDayInfosWithStartIndex:((JSLFestivalInfo *)self.dayInfos.lastObject).bigDayId totalCount:20 result:^(JSLResult *result) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.dayInfos];
        [tmpArr addObjectsFromArray:result.result];
        weakSelf.dayInfos = tmpArr;
        [weakSelf.collectionView reloadData];
        [weakSelf checkHasMore:result];
    }];
}

- (CGFloat)caculteHeightWithDayInfo:(JSLFestivalInfo *)dayInfo
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize nameSize = [dayInfo.bigDayName boundingRectWithSize:CGSizeMake((self.view.bounds.size.width - 30)/2 - 20, MAXFLOAT)
                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]
                                               context:nil].size;
    
    UIFont *remarkFont = [UIFont systemFontOfSize:13.0];
    CGSize remarkSize = [dayInfo.bigDayRemark boundingRectWithSize:CGSizeMake((self.view.bounds.size.width - 30)/2 - 20, MAXFLOAT)
                                                       options:(NSStringDrawingUsesLineFragmentOrigin)
                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:remarkFont,NSFontAttributeName, nil]
                                                       context:nil].size;
    
    if (dayInfo.bigDayRemark.length == 0) {
        return nameSize.height + 55;
    } else {
        return nameSize.height + remarkSize.height + 60 + 15;
    }
}

- (void)checkHasMore:(JSLResult *)result
{
    [self setTableViewMJFooter];
    
    if (((NSArray *)result.result).count == 20) {
        [self.collectionView.mj_footer endRefreshing];
    } else {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)setTableViewMJFooter
{
    if (self.dayInfos.count == 0) {
        [self.collectionView setMj_footer:nil];
    } else {
        [self.collectionView setMj_footer:self.refreshFooter];
    }
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        JSLFestivalCollectionViewLayout *layout = [[JSLFestivalCollectionViewLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JSLFestivalCollectionViewCell class]
            forCellWithReuseIdentifier:festivalCollectionViewCellIdentifier];
    }

    return _collectionView;
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
    JSLPublishFestivalViewController *vc = [[JSLPublishFestivalViewController alloc] init];
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

- (void)refreshList:(NSNotification *)notification
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.dayInfos];
    [tmpArr insertObject:(JSLFestivalInfo *)notification.object atIndex:0];
    self.dayInfos = tmpArr;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];//回到顶部
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSLFestivalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:festivalCollectionViewCellIdentifier
                                                                                 forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell updateCellWithDayInfo:self.dayInfos[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSLFestivalInfo *dayInfo = self.dayInfos[indexPath.row];
    CGFloat cellHeight = [self caculteHeightWithDayInfo:dayInfo];
    return CGSizeMake((self.view.bounds.size.width - 30)/2, cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JSLFestivalCollectionViewLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSLFestivalInfo *dayInfo = self.dayInfos[indexPath.row];
    return [self caculteHeightWithDayInfo:dayInfo];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    JSLFestivalInfo *dayInfo = self.dayInfos[indexPath.row];
    if (self.editingIndexPath == indexPath) {
        dayInfo.showDelete = !dayInfo.showDelete;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        if (!self.editingIndexPath) {
            dayInfo.showDelete = YES;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            self.editingIndexPath = indexPath;
        } else {
            dayInfo.showDelete = YES;
            JSLFestivalInfo *editingInfo = self.dayInfos[self.editingIndexPath.row];
            editingInfo.showDelete = NO;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath, self.editingIndexPath]];
            self.editingIndexPath = indexPath;
        }
    }
}

#pragma mark - JSLFestivalCollectionViewCellDelegate

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除这条记录吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        JSLFestivalInfo *dayInfo = weakSelf.dayInfos[indexPath.row];
        dayInfo.showDelete = NO;
        [weakSelf.collectionView reloadData];
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[JSLFestivalManager sharedManager] deleteBigDayInfo:weakSelf.dayInfos[indexPath.row] result:^{
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.dayInfos];
            [tmpArr removeObjectAtIndex:indexPath.row];
            weakSelf.dayInfos = tmpArr;
            [weakSelf.collectionView reloadData];
        }];
    }];
    
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirmAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}

@end
