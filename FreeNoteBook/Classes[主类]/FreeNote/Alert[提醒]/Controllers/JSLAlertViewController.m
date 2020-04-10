
#import "JSLAlertViewController.h"
#import "JSLPublishAlertViewController.h"
#import "JSLBaseNavigationController.h"
#import "JSLAlertTableViewCell.h"
#import "JSLAlertManager.h"
#import "UIView+JSLTips.h"
#import "JSLMaskView.h"

@interface JSLAlertViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray  *alertInfos;
@property (nonatomic, strong) JSLMaskView  *maskView;

@end

static NSString *alertTableViewCellIdentifier = @"alertTableViewCellIdentifier";
static NSString *alertTableViewHeaderIdentifier = @"alertTableViewHeaderIdentifier";

@implementation JSLAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:alertPublishSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:alertStateChangedNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.title = STR_MAIN_MENU_ITEM_ALERT;
    
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    
    [self.view addSubview:self.tableView];
}

- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopWhite];
    __weak __typeof(&*self)weakSelf = self;
    [[JSLAlertManager sharedManager] fetchAlertInfosWithResult:^(JSLResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.alertInfos = result.result;
        [weakSelf.tableView reloadData];
        if (weakSelf.alertInfos.count == 3) {
            if (((NSArray *)weakSelf.alertInfos[0]).count == 0 && ((NSArray *)weakSelf.alertInfos[1]).count == 0 && ((NSArray *)weakSelf.alertInfos[2]).count == 0) {
                [weakSelf.maskView show];
            }
        }
    }];
}

- (UIColor *)buildColor:(NSInteger)index
{
    UIColor *color;
    switch (index) {
        case 0:
            color = UIColorFromHexRGB(0x00BEFE);
            break;
            
        case 1:
            color =  UIColorFromHexRGB(0xFF8001);
            break;
            
        case 2:
            color = UIColorFromHexRGB(0x7ABA00);
            break;
            
        default:
            break;
    }
    
    return color;
}

- (void)refreshList:(NSNotification *)notification
{
    if ([self.alertInfos[0] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.alertInfos[0]];
        [tmpArr insertObject:(JSLAlertInfo *)notification.object atIndex:0];
        
        NSMutableArray *infosArr = [NSMutableArray arrayWithArray:self.alertInfos];
        [infosArr replaceObjectAtIndex:0 withObject:tmpArr];
        self.alertInfos = infosArr;
        
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO]; // 回到顶部
    }
}

- (void)updateUI:(NSIndexPath *)indexPath
{
    NSArray *infos = self.alertInfos[indexPath.section];
    JSLAlertInfo *info = infos[indexPath.row];
    info.isComplete = YES;
    
    NSMutableArray *completeArr = [NSMutableArray arrayWithArray:self.alertInfos[2]];
    [completeArr insertObject:info atIndex:0];
    
    NSMutableArray *finishArr = [NSMutableArray arrayWithArray:self.alertInfos[1]];
    [finishArr removeObject:info];
    
    NSMutableArray *alertArr = [NSMutableArray arrayWithArray:self.alertInfos];
    [alertArr replaceObjectAtIndex:1 withObject:finishArr];
    [alertArr replaceObjectAtIndex:2 withObject:completeArr];
    
    self.alertInfos = alertArr;
    
    [self.tableView reloadData];
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSLAlertTableViewCell class] forCellReuseIdentifier:alertTableViewCellIdentifier];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:alertTableViewHeaderIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
    JSLPublishAlertViewController *vc = [[JSLPublishAlertViewController alloc] init];
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


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.alertInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id infos = self.alertInfos[section];
    if ([infos isKindOfClass:[NSArray class]]) {
        return ((NSArray *)infos).count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:alertTableViewCellIdentifier forIndexPath:indexPath];
    if (self.alertInfos.count > 0) {
        if (((NSArray *)self.alertInfos[indexPath.section]).count > 0) {
            NSArray *infos = (NSArray *)self.alertInfos[indexPath.section];
            [cell updateCellWithAlertInfo:infos[indexPath.row] color:[self buildColor:indexPath.section]];
            return cell;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.alertInfos[indexPath.section] isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.alertInfos[indexPath.section];
        return arr.count == 0 ? 0 : JSL_AUTOSIZING_HEIGTH_SCALE(160.0f);
    }
    return JSL_AUTOSIZING_HEIGTH_SCALE(160.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:alertTableViewHeaderIdentifier];
    headerView.contentView.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:alertTableViewHeaderIdentifier];
    view.contentView.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
    return view;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置删除按钮
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
        [[JSLAlertManager sharedManager] deleteAlertInfo:((NSArray *)weakSelf.alertInfos[indexPath.section])[indexPath.row] result:nil];
        
        NSMutableArray *alertInfos = [NSMutableArray arrayWithArray:weakSelf.alertInfos[indexPath.section]];
        [alertInfos removeObjectAtIndex:indexPath.row];
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.alertInfos];
        [tmpArr replaceObjectAtIndex:indexPath.section withObject:alertInfos];
        weakSelf.alertInfos = tmpArr;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    // 标记为已完成
    UITableViewRowAction *completeRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"已完成", nil) handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        NSArray *infos = self.alertInfos[indexPath.section];
        JSLAlertInfo *info = infos[indexPath.row];
        [[JSLAlertManager sharedManager] updateAlertIsCompleteWithAlertId:info.alertId result:nil];
        [weakSelf updateUI:indexPath];
    }];
    
    completeRowAction.backgroundColor = UIColorFromHexRGB(0x7ABA00);
    
    NSArray *infos = self.alertInfos[indexPath.section];
    JSLAlertInfo *alertInfo = infos[indexPath.row];
    if (alertInfo.isFinish && !alertInfo.isComplete) {
        return @[deleteRowAction, completeRowAction];
    } else {
        return @[deleteRowAction];
    }
}


@end

