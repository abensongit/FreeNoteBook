
#import "JSLPlaceViewController.h"
#import "JSLPlacePublishSheet.h"
#import "JSLPlaceManager.h"
#import "UIView+JSLTips.h"
#import "MJRefresh.h"
#import "JSLCardCollectionViewCell.h"
#import "JSLCardLayout.h"
#import "JSLCardSelectedLayout.h"
#import "UIView+JSLTips.h"
#import "JSLMaskView.h"

@interface JSLPlaceViewController() <JSLPlacePublishSheetDelegate, UICollectionViewDelegate, UICollectionViewDataSource,JSLCardLayoutDelegate, JSLCardCollectionViewCellDelegate>

@property (nonatomic, strong) JSLPlacePublishSheet      *publishSheet;
@property (nonatomic, strong) UICollectionView          *cardCollectionView;
@property (nonatomic, strong) UICollectionViewLayout    *cardLayout;
@property (nonatomic, strong) UICollectionViewLayout    *cardLayoutStyle1;
@property (nonatomic, strong) UICollectionViewLayout    *cardLayoutStyle2;
@property (nonatomic, strong) UITapGestureRecognizer    *tapGesture;
@property (nonatomic, strong) NSArray                   *placeInfos;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;
@property (nonatomic, strong) JSLMaskView  *maskView;

@end

static NSString *placeCollectionViewCellIdentifier = @"placeCollectionViewCellIdentifier";

@implementation JSLPlaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self loadData];
}

#pragma mark - Getter

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBackGround)];
    }
    return _tapGesture;
}

- (UICollectionView *)cardCollectionView
{
    if (!_cardCollectionView) {
        _cardCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, self.view.bounds.size.height)
                                                 collectionViewLayout:self.cardLayout];
        [_cardCollectionView registerClass:[JSLCardCollectionViewCell class]
                forCellWithReuseIdentifier:placeCollectionViewCellIdentifier];
        _cardCollectionView.delegate = self;
        _cardCollectionView.dataSource = self;
        [_cardCollectionView setContentOffset:CGPointMake(0, 400)];
        _cardCollectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _cardCollectionView;
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
        _refreshFooter.stateLabel.textColor = [UIColor lightGrayColor];
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
    self.publishSheet = [[JSLPlacePublishSheet alloc] init];
    self.publishSheet.delegate = self;
    [self.publishSheet show];
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

- (void)tapOnBackGround
{
    CGFloat offsetY = self.cardCollectionView.contentOffset.y;
    if (![self.cardLayout isKindOfClass:[JSLCardLayout class]]) {
        if (!self.cardLayoutStyle1) {
            self.cardLayoutStyle1 = [[JSLCardLayout alloc] initWithOffsetY:offsetY];
            self.cardLayout = self.cardLayoutStyle1;
            ((JSLCardLayout *)self.cardLayoutStyle1).delegate = self;
        } else {
            ((JSLCardLayout *)self.cardLayoutStyle1).offsetY = offsetY;
            self.cardLayout = self.cardLayoutStyle1;
        }
        
        self.cardCollectionView.scrollEnabled = YES;
        [self.cardCollectionView removeGestureRecognizer:self.tapGesture];
    }
    
    [self.cardCollectionView setCollectionViewLayout:self.cardLayout animated:YES];
    [self updateBlur];
}

#pragma mark - Private

- (void)initUI
{
    self.title = STR_MAIN_MENU_ITEM_PLACE;
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;

    self.cardLayoutStyle1 = [[JSLCardLayout alloc] initWithOffsetY:400];
    self.cardLayout = self.cardLayoutStyle1;
    ((JSLCardLayout *)self.cardLayoutStyle1).delegate = self;
    
    [self.view addSubview:self.cardCollectionView];
    self.cardCollectionView.mj_footer = self.refreshFooter;
}

- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[JSLPlaceManager sharedManager] fetchPlaceInfosWithStartIndex:0 totalCount:10 result:^(JSLResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.placeInfos = result.result;
        if (weakSelf.placeInfos.count > 0) {
            [weakSelf.cardCollectionView reloadData];
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
    [[JSLPlaceManager sharedManager] fetchPlaceInfosWithStartIndex:((JSLPlaceInfo *)self.placeInfos.lastObject).placeId totalCount:10 result:^(JSLResult *result) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.placeInfos];
        [tmpArr addObjectsFromArray:result.result];
        weakSelf.placeInfos = tmpArr;
        [weakSelf.cardCollectionView reloadData];
        [weakSelf checkHasMore:result];
    }];
}

- (UIColor *)getRandomColor:(NSInteger)index
{
    NSArray *colorList = @[UIColorFromHexRGB(0x00BEFE),
                           UIColorFromHexRGB(0xFD2B61),
                           UIColorFromHexRGB(0x7ABA00),
                           UIColorFromHexRGB(0xFF8001),
                           UIColorFromHexRGB(0xB01F00),
                           UIColorFromHexRGB(0x8C88FE)];
    UIColor *color = [colorList objectAtIndex:(index % 6)];
    return color;
}

- (void)updateBlur
{
    if ([self.cardLayout isKindOfClass:[JSLCardLayout class]]) {
        for (NSInteger row = 0; row < [self.cardCollectionView numberOfItemsInSection:0]; row++) {
            JSLCardCollectionViewCell *cell = (JSLCardCollectionViewCell *)[self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            CGFloat blur = ((NSNumber *)[((JSLCardLayout *)self.cardLayout).blurList objectAtIndex:row]).floatValue;
            [cell setBlur:blur];
        }
    } else {
        for (NSInteger row = 0; row < [self.cardCollectionView numberOfItemsInSection:0]; row++) {
            JSLCardCollectionViewCell *cell = (JSLCardCollectionViewCell *)[self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            [cell setBlur:0];
        }
    }
}

- (void)showMaskView
{
    self.cardCollectionView.backgroundColor = [UIColor whiteColor];
    [self.cardCollectionView addGestureRecognizer:self.tapGesture];
}

- (void)hideMaskView
{
    self.cardCollectionView.backgroundColor = [UIColor whiteColor];
    [self.cardCollectionView removeGestureRecognizer:self.tapGesture];
}

- (void)checkHasMore:(JSLResult *)result
{
    if (((NSArray *)result.result).count == 10) {
        [self.cardCollectionView.mj_footer endRefreshing];
    } else {
        [self.cardCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.placeInfos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSLCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:placeCollectionViewCellIdentifier
                                                                               forIndexPath:indexPath];
    [cell updateCellWithPlaceInfo:self.placeInfos[indexPath.row]
                          bgColor:[self getRandomColor:indexPath.row]];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat offsetY = self.cardCollectionView.contentOffset.y;
    if ([self.cardLayout isKindOfClass:[JSLCardLayout class]]) {
        if (!self.cardLayoutStyle2) {
            self.cardLayoutStyle2 = [[JSLCardSelectedLayout alloc] initWithIndexPath:indexPath
                                                                            offsetY:offsetY
                                                                  ContentSizeHeight:((JSLCardLayout*)self.cardLayout).contentSizeHeight];
            self.cardLayout = self.cardLayoutStyle2;
        } else {
            ((JSLCardSelectedLayout *)self.cardLayoutStyle2).contentOffsetY = offsetY;
            ((JSLCardSelectedLayout *)self.cardLayoutStyle2).contentSizeHeight = ((JSLCardLayout *)self.cardLayout).contentSizeHeight;
            ((JSLCardSelectedLayout *)self.cardLayoutStyle2).selectedIndexPath = indexPath;
            self.cardLayout = self.cardLayoutStyle2;
        }
        
        self.cardCollectionView.scrollEnabled = NO;
        [self showMaskView];//显示背景浮层
        //选中的卡片不显示蒙层
        [((JSLCardCollectionViewCell *)[self.cardCollectionView cellForItemAtIndexPath:indexPath]) setBlur:0];
    } else {
        if (!self.cardLayoutStyle1) {
            self.cardLayoutStyle1 = [[JSLCardLayout alloc] initWithOffsetY:offsetY];
            self.cardLayout = self.cardLayoutStyle1;
            ((JSLCardLayout *)self.cardLayoutStyle1).delegate = self;
        } else {
            ((JSLCardLayout *)self.cardLayoutStyle1).offsetY = offsetY;
            self.cardLayout = self.cardLayoutStyle1;
            ((JSLCardLayout *)self.cardLayoutStyle1).delegate = self;
        }
        
        self.cardCollectionView.scrollEnabled = YES;
        [self hideMaskView];
    }
    
    [self.cardCollectionView setCollectionViewLayout:self.cardLayout animated:YES];
}

#pragma mark - JSLCardLayoutDelegate

- (void)updateBlur:(CGFloat)blur ForRow:(NSInteger)row
{
    if (![self.cardLayout isKindOfClass:[JSLCardLayout class]]) {
        return;
    }
    
    JSLCardCollectionViewCell *cell = (JSLCardCollectionViewCell *)[self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setBlur:blur];
}

#pragma mark - JSLPlacePublishSheetDelegate

- (void)confirmWithPlaceInfo:(JSLPlaceInfo *)placeInfo
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[JSLPlaceManager sharedManager] cachePlaceInfo:placeInfo result:^{
        [weakSelf.view hideManualTips];
        [weakSelf.publishSheet dismiss];
        
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.placeInfos];
        [tmpArr insertObject:placeInfo atIndex:0];
        weakSelf.placeInfos = tmpArr;
        [weakSelf.cardCollectionView reloadData];
    }];
}

#pragma mark - JSLCardCollectionViewCellDelegate

- (void)deleteIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除这条记录吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[JSLPlaceManager sharedManager] deletePlaceInfo:weakSelf.placeInfos[indexPath.row] result:^{
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.placeInfos];
            [tmpArr removeObjectAtIndex:indexPath.row];
            weakSelf.placeInfos = tmpArr;
            [weakSelf.cardCollectionView reloadData];
        }];
    }];
    
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirmAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}

@end

