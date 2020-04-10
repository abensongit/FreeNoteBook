
#import "JSLMainMenuViewController.h"
#import "JSLMainMenuCollectionViewCell.h"
#import "JSLSettingViewController.h"
#import "JSLDiaryViewController.h"
#import "JSLFestivalViewController.h"
#import "JSLPlaceViewController.h"
#import "JSLAlertViewController.h"
#import "JSLBillViewController.h"
#import "JSLMainMenuManager.h"

static NSString *mainMenuCollectionViewCellIdentifier = @"mainMenuCollectionViewCellIdentifier";
static NSString *mainMenuCollectionResuableViewIdentifier = @"mainMenuCollectionResuableViewIdentifier";

@interface JSLMainMenuViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray          *menuItemArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JSLMainMenuViewController

#pragma mark -
#pragma mark 视图生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    [self.view addSubview:self.collectionView];
    [self checkToClearNotifications];
}

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - Private

- (void)checkToClearNotifications
{
    __weak typeof(self) weakSelf = self;
    [[JSLMainMenuManager sharedManager] fetchConfigInfoWithResultBlock:^(JSLResult *result) {
        JSLAlertConfigInfo *configInfo = result.result;
        if (!configInfo.hasClearAlert) {
            [weakSelf clearNotifications];
        }
    }];
}

- (void)clearNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    JSLAlertConfigInfo *configInfo = [[JSLAlertConfigInfo alloc] init];
    configInfo.hasClearAlert = YES;
    [[JSLMainMenuManager sharedManager] cacheConfigInfo:configInfo];
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
        [_collectionView registerClass:[JSLMainMenuCollectionViewCell class]
            forCellWithReuseIdentifier:mainMenuCollectionViewCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:mainMenuCollectionResuableViewIdentifier];
    }

    return _collectionView;
}

- (NSArray *)menuItemArr
{
    if (!_menuItemArr) {
        _menuItemArr = @[STR_MAIN_MENU_ITEM_DIARIES,
                         STR_MAIN_MENU_ITEM_BILLS,
                         STR_MAIN_MENU_ITEM_FESTIVAL,
                         STR_MAIN_MENU_ITEM_PLACE,
                         STR_MAIN_MENU_ITEM_ALERT,
                         STR_MAIN_MENU_ITEM_SETTING];
    }
    
    return _menuItemArr;
}

#pragma mark - Action

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *menuTitle = self.menuItemArr[indexPath.row];
    
    UIViewController *viewController = nil;
    if ([menuTitle isEqualToString:STR_MAIN_MENU_ITEM_DIARIES]) {
        viewController = [[JSLDiaryViewController alloc] init];
    } else if ([menuTitle isEqualToString:STR_MAIN_MENU_ITEM_BILLS]) {
        viewController = [[JSLBillViewController alloc] init];
    } else if ([menuTitle isEqualToString:STR_MAIN_MENU_ITEM_FESTIVAL]) {
        viewController = [[JSLFestivalViewController alloc] init];
    } else if ([menuTitle isEqualToString:STR_MAIN_MENU_ITEM_PLACE]) {
        viewController = [[JSLPlaceViewController alloc] init];
    } else if ([menuTitle isEqualToString:STR_MAIN_MENU_ITEM_ALERT]) {
        viewController = [[JSLAlertViewController alloc] init];
    } else if ([menuTitle isEqualToString:STR_MAIN_MENU_ITEM_SETTING]) {
        viewController = [[JSLSettingViewController alloc] init];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuItemArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSLMainMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainMenuCollectionViewCellIdentifier
                                                                                    forIndexPath:indexPath];
    [cell updateCellWithTitle:self.menuItemArr[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight = JSL_AUTOSIZING_WIDTH_SCALE(120.0f);
    switch (indexPath.row) {
        case 0: case 3: case 4:
            return CGSizeMake((self.view.frame.size.width - 50) / 2 + 50, itemHeight);
            break;
            
        case 1: case 2: case 5:
            return CGSizeMake((self.view.frame.size.width - 50) / 2 - 50, itemHeight);
            break;
            
        default:
            break;
    }
    
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat itemHeight = JSL_AUTOSIZING_WIDTH_SCALE(120.0f);
    CGFloat navBarHeight = [self prefersStatusBarHidden] ? STATUS_NAVIGATION_BAR_HEIGHT : (IS_IPHONE_X_OR_GREATER ? STATUS_NAVIGATION_BAR_HEIGHT : NAVIGATION_BAR_HEIGHT);
    CGFloat height = ([UIApplication sharedApplication].delegate.window.bounds.size.height - itemHeight * 3 - 10 * 2) / 2.0f - navBarHeight;
    if (IS_IPHONE_4_OR_LESS) {
        height = ([UIApplication sharedApplication].delegate.window.bounds.size.height - itemHeight * 3 - 10 * 2) / 2.0f;
    }
    return CGSizeMake(self.view.frame.size.width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:mainMenuCollectionResuableViewIdentifier
                                                                                             forIndexPath:indexPath];
    headerView.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self didSelectItemAtIndexPath:indexPath];
}

@end

