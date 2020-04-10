
#import "JSLDiaryShowViewController.h"
#import "JSLDiaryShowHeaderView.h"
#import "JSLDiaryShowTableViewCell.h"
#import "JSLDiaryEditViewController.h"
#import "JSLBaseNavigationController.h"
#import "JSLDiaryManager.h"
#import "JSLShowPhotoTool.h"

@interface JSLDiaryShowViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat     contentHeight;
@property (nonatomic, strong) JSLShowPhotoTool *tool;

@end

static NSString *diaryShowTableViewCellIdentifier = @"diaryShowTableViewCellIdentifier";
static NSString *diaryShowTableViewHeaderViewIdentifier = @"diaryShowTableViewHeaderViewIdentifier";

@implementation JSLDiaryShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPage)
                                                 name:diaryUpdateSuccessNotification
                                               object:nil];
    [self loadImage];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"详情", nil);
    [self.view addSubview:self.tableView];
}


- (void)loadImage
{
    __weak typeof(self) weakSelf = self;
    [[JSLDiaryManager sharedManager] selectImageWithDiaryId:self.diaryInfo.diaryId result:^(JSLResult *result) {
        weakSelf.diaryInfo.diaryImage = result.result;
        [weakSelf.tableView reloadData];
    }];
}


- (CGFloat)caculteHeightWithContent:(NSString *)content
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 30, MAXFLOAT)
                                                              options:(NSStringDrawingUsesLineFragmentOrigin)
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]
                                                              context:nil].size;
    
    return contentSize.height;
}

#pragma mark - Action

- (void)pressNavigationBarRightButtonItem:(id)sender
{
    JSLDiaryEditViewController *vc = [[JSLDiaryEditViewController alloc] init];
    vc.diaryInfo = self.diaryInfo;
    JSLBaseNavigationController *nav = [[JSLBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


- (JSLNavBarButtonItemType)prefersNavigationBarLeftButtonItemType
{
    return JSLNavBarButtonItemTypeDefault;
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
    return ICON_DIARY_CONTENT_EDIT;
}

- (NSString *)prefersNavigationBarRightButtonItemImageSelect
{
    return ICON_DIARY_CONTENT_EDIT;
}

- (void)refreshPage
{
    self.contentHeight = [self caculteHeightWithContent:self.diaryInfo.diaryContent];
    [self.tableView reloadData];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSLDiaryShowTableViewCell class]
           forCellReuseIdentifier:diaryShowTableViewCellIdentifier];
        [_tableView registerClass:[JSLDiaryShowHeaderView class] forHeaderFooterViewReuseIdentifier:diaryShowTableViewHeaderViewIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}


- (void)setDiaryInfo:(JSLDiaryInfo *)diaryInfo
{
    _diaryInfo = diaryInfo;
    _contentHeight = [self caculteHeightWithContent:diaryInfo.diaryContent];
}

- (JSLShowPhotoTool *)tool
{
    if (!_tool) {
        _tool = [[JSLShowPhotoTool alloc] init];
    }

    return _tool;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLDiaryShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryShowTableViewCellIdentifier
                                                                   forIndexPath:indexPath];
    if (self.diaryInfo.diaryImage) {
        [cell updateCellWithImage:self.diaryInfo.diaryImage];
    } else {
        [cell updateCellWithImage:self.diaryInfo.diaryMiddleImage];
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JSLDiaryShowHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:diaryShowTableViewHeaderViewIdentifier];
    [headerView updateViewWithDiaryInfo:self.diaryInfo];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.contentHeight + 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.diaryInfo.diaryImage) {
        return;
    }
    
    [self.tool showWithImage:self.diaryInfo.diaryImage];
}

@end
