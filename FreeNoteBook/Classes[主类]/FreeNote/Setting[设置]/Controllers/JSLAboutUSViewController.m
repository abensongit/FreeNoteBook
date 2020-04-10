
#import "JSLAboutUSViewController.h"
#import "JSLDeviceUtil.h"

@interface JSLAboutUSViewController ()

@property (nonatomic, strong) UILabel     *appInfoLabel;
@property (nonatomic, strong) UILabel     *introduceLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation JSLAboutUSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = STR_SETTING_MENU_ITEM_ABOUT;
    self.view.backgroundColor = [JSLThemeConfig currentTheme].mainBGColor;
    
    __weak __typeof(&*self)weakSelf = self;
    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(30);
    }];
    
    [self.view addSubview:self.introduceLabel];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(40);
        make.top.equalTo(weakSelf.view).with.offset(100);
    }];
    
    [self.view addSubview:self.appInfoLabel];
    [self.appInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(40);
        make.top.equalTo(weakSelf.view).with.offset(130);
    }];
}


- (UILabel *)appInfoLabel
{
    if (!_appInfoLabel) {
        NSString *appInfo = [NSString stringWithFormat:@"%@  版本 Version %@",
                             [JSLDeviceUtil sharedDevice].appName,
                             [JSLDeviceUtil sharedDevice].appVersion];
        _appInfoLabel = [[UILabel alloc] init];
        _appInfoLabel.text = appInfo;
        _appInfoLabel.textColor = UIColorFromHexRGB(0x333333);
        _appInfoLabel.font = [UIFont systemFontOfSize:13.0];
        _appInfoLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _appInfoLabel;
}


- (UILabel *)introduceLabel
{
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.text = NSLocalizedString(@"让记录更简单", nil);
        _introduceLabel.textColor = UIColorFromHexRGB(0x333333);
        _introduceLabel.font = [UIFont systemFontOfSize:15.0];
        _introduceLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _introduceLabel;
}


- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.image = [JSLDeviceUtil sharedDevice].appIcon;
        _iconImageView.layer.cornerRadius = 5.0;
        _iconImageView.clipsToBounds = YES;
        
    }

    return _iconImageView;
}

@end
