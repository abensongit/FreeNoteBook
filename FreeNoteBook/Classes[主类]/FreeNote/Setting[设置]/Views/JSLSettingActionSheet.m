
#import "JSLSettingActionSheet.h"
#import "JSLSettingActionCell.h"

@interface JSLSettingActionSheet() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *itemArr;

@end

static NSString *settingSelectHeadCellIdentifier = @"settingSelectHeadCellIdentifier";

@implementation JSLSettingActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }

    return self;
}

#pragma mark - Action

- (void)takePhoto
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(takePhoto)]) {
        [self.delegate takePhoto];
    }
}

- (void)selectFromAlbum
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFromAlbum)]) {
        [self.delegate searchFromAlbum];
    }
}

#pragma mark - Private

- (void)initUI
{
    [self.bgView addSubview:self.tapView];
    [self.bgView addSubview:self.tableView];
}

#pragma mark - Getter

- (UIView *)bgView
{
    if (!_bgView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _bgView = [[UIView alloc] initWithFrame:rect];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }

    return _bgView;
}

- (UIView *)tapView
{
    if (!_tapView) {
        CGFloat height = IS_IPHONE_X_OR_GREATER ? (JSL_AUTOSIZING_WIDTH_SCALE(55.0f)*3.0f +TAB_BAR_DANGER_HEIGHT + JSL_AUTOSIZING_MARGIN(MARGIN)) : (JSL_AUTOSIZING_WIDTH_SCALE(55.0f)*3.0f + JSL_AUTOSIZING_MARGIN(MARGIN));
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - height)];
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_tapView addGestureRecognizer:gesture];
    }
    
    return _tapView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat height = IS_IPHONE_X_OR_GREATER ? (JSL_AUTOSIZING_WIDTH_SCALE(55.0f)*3.0f +TAB_BAR_DANGER_HEIGHT + JSL_AUTOSIZING_MARGIN(MARGIN)) : (JSL_AUTOSIZING_WIDTH_SCALE(55.0f)*3.0f + JSL_AUTOSIZING_MARGIN(MARGIN));
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, height)
                                                  style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[JSLSettingActionCell class]
           forCellReuseIdentifier:settingSelectHeadCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (NSArray *)itemArr
{
    if (!_itemArr) {
        NSArray *selectArr = @[ STR_SETTING_MENU_HEAD_TAKE_PHOTO, STR_SETTING_MENU_HEAD_PHOTO_ALBUM ];
        NSArray *cancelArr = @[ STR_SETTING_MENU_HEAD_CANCLE ];
        _itemArr = @[ selectArr, cancelArr ];
    }

    return _itemArr;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.itemArr[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLSettingActionCell *cell = [tableView dequeueReusableCellWithIdentifier:settingSelectHeadCellIdentifier];
    NSString *title = ((NSArray *)self.itemArr[indexPath.section])[indexPath.row];
    [cell updateCellWithTitle:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return JSL_AUTOSIZING_WIDTH_SCALE(55.0f);
    } else if (1 == indexPath.section) {
        return IS_IPHONE_X_OR_GREATER ? JSL_AUTOSIZING_WIDTH_SCALE(55.0f) : JSL_AUTOSIZING_WIDTH_SCALE(55.0f);
    }
    return JSL_AUTOSIZING_WIDTH_SCALE(55.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? FLOAT_MIN : JSL_AUTOSIZING_MARGIN(MARGIN);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] init];
    sectionFooterView.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    return sectionFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
    NSString *title = ((NSArray *)self.itemArr[indexPath.section])[indexPath.row];
    if ([title isEqualToString:STR_SETTING_MENU_HEAD_TAKE_PHOTO]) {
        [self takePhoto];
    } else if ([title isEqualToString:STR_SETTING_MENU_HEAD_PHOTO_ALBUM]) {
        [self selectFromAlbum];
    } else if ([title isEqualToString:STR_SETTING_MENU_HEAD_CANCLE]) {
        [self dismiss];
    }
}

#pragma mark - Public

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
    CGRect frame = self.tableView.frame;
    CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
    frame.origin.y = rect.size.height - frame.size.height;
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    CGRect frame = self.tableView.frame;
    CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
    frame.origin.y = rect.size.height;
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}


@end

