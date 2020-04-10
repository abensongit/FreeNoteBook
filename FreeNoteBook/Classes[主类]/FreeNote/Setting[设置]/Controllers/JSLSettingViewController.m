
#import "JSLSettingViewController.h"
#import "JSLSettingTableViewCell.h"
#import "JSLSettingHeaderView.h"
#import "JSLMainMenuManager.h"
#import "JSLSettingActionSheet.h"
#import "JSLMainMenuManager.h"
#import "JSLAboutUSViewController.h"
#import "FSMediaPicker.h"
#import "JSLShowPhotoTool.h"

@interface JSLSettingViewController () <UITableViewDelegate, UITableViewDataSource, JSLSettingActionSheetDelegate, FSMediaPickerDelegate, JSLSettingHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *settingItemArr;
@property (nonatomic, strong) JSLSettingActionSheet *actionSheet;
@property (nonatomic, strong) JSLMainMenuHeadInfo *headInfo;
@property (nonatomic, strong) JSLShowPhotoTool *tool;

@end

static NSString *settingTableViewCellIdentifier = @"settingTableViewCellIdentifier";
static NSString *settingTableViewHeaderViewIdentifier = @"settingTableViewHeaderViewIdentifier";

@implementation JSLSettingViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = STR_MAIN_MENU_ITEM_SETTING;
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

#pragma mark - Getter/Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSLSettingTableViewCell class] forCellReuseIdentifier:settingTableViewCellIdentifier];
        [_tableView registerClass:[JSLSettingHeaderView class] forHeaderFooterViewReuseIdentifier:settingTableViewHeaderViewIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}

- (NSArray *)settingItemArr
{
    if (!_settingItemArr) {
        _settingItemArr = @[ STR_SETTING_MENU_ITEM_HEAD,
                             STR_SETTING_MENU_ITEM_ABOUT
                             //,STR_SETTING_MENU_ITEM_COMMENT
                             ];
    }

    return _settingItemArr;
}

- (JSLSettingActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[JSLSettingActionSheet alloc] init];
        _actionSheet.delegate = self;
    }

    return _actionSheet;
}

- (JSLMainMenuHeadInfo *)headInfo
{
    if (!_headInfo) {
        _headInfo = [[JSLMainMenuHeadInfo alloc] init];
    }

    return _headInfo;
}

- (JSLShowPhotoTool *)tool
{
    if (!_tool) {
        _tool = [[JSLShowPhotoTool alloc] init];
    }
    return _tool;
}

#pragma mark - Action

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.settingItemArr[indexPath.row];
    if ([title isEqualToString:STR_SETTING_MENU_ITEM_HEAD]) {
        [self selectHeadPicture];
    } else if ([title isEqualToString:STR_SETTING_MENU_ITEM_ABOUT]) {
        JSLAboutUSViewController *aboutUsVC = [[JSLAboutUSViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    } else if ([title isEqualToString:STR_SETTING_MENU_ITEM_COMMENT]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?"]];
    }
}

#pragma mark - Private

- (void)loadData
{
    __weak __typeof(&*self)weakSelf = self;
    [[JSLMainMenuManager sharedManager] fetchHeadInfoWithResultBlock:^(JSLResult *result) {
        weakSelf.headInfo = result.result;
        [weakSelf.tableView reloadData];
    }];
}

- (void)selectHeadPicture
{
    [self.actionSheet show];
}

- (void)checkAuthorizationWithType:(JSLSettingHeadImageType)type complete:(void (^) (void))complete
{
    switch (type) {
        case kJSLSettingHeadImageTypeCamera: // 检查相机授权
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                switch (authStatus) {
                    case AVAuthorizationStatusAuthorized:
                        if (complete) {
                            complete();
                        }
                        break;
                    case AVAuthorizationStatusNotDetermined:
                    {
                        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                            dispatch_async_in_main_queue(^{
                                if (granted && complete) {
                                    complete();
                                }
                            });
                        }];
                    }
                        break;
                    default:
                    {
                        [self.view showMultiLineMessage:NSLocalizedString(([NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，允许%@访问你的相机",
                                                                           [JSLDeviceUtil sharedDevice].appName]), nil)];
                    }
                        break;
                }
            } else {
                [JSLTips show:NSLocalizedString(@"您的设备不支持拍照", nil)];
            }
        }
            break;
        case kJSLSettingHeadImageTypeAlbum: // 检查相册授权
        {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            switch (status) {
                case ALAuthorizationStatusNotDetermined:
                case ALAuthorizationStatusAuthorized:
                    if (complete) {
                        complete();
                    }
                    break;
                default:
                {
                    [self.view showMultiLineMessage:NSLocalizedString(([NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，允许%@访问你的相册",
                                                                        [JSLDeviceUtil sharedDevice].appName]), nil)];
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
}


- (void)refreshHead:(UIImage *)image
{
    self.headInfo.headImage = image;
    [[JSLMainMenuManager sharedManager] cacheHeadInfo:self.headInfo];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingItemArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSL_AUTOSIZING_WIDTH_SCALE(50.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSLSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingTableViewCellIdentifier
                                    forIndexPath:indexPath];
    [cell updateCellWithTitle:self.settingItemArr[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JSLSettingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:settingTableViewHeaderViewIdentifier];
    [headerView updateViewWithImage:self.headInfo.headImage];
    headerView.delegate = self;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return JSL_AUTOSIZING_WIDTH_SCALE(150.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self didSelectItemAtIndexPath:indexPath];
}

#pragma mark - JSLSettingHeaderViewDelegate

- (void)showBigHighDefinitionImage
{
    UIImage *image = self.headInfo.headImage ? self.headInfo.headImage : [UIImage imageNamed:ICON_HEAD_DEFAULT];
    [self.tool showWithImage:image];
}

#pragma mark - JSLSettingActionSheetDelegate

- (void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kJSLSettingHeadImageTypeCamera complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeStandard;
        [mediaPicker takePhotoFromCamera];
    }];
}

- (void)searchFromAlbum
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kJSLSettingHeadImageTypeAlbum complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeStandard;
        [mediaPicker takePhotoFromPhotoLibrary];
    }];
}

#pragma mark - FSMediaPickerDelegate

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [self refreshHead:mediaInfo.editedImage];
}


@end
