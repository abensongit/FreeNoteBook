
#import "JSLSafariViewController.h"
#import "JSLAssistiveTouchButton.h"

@interface JSLSafariViewController () <JSLAssistiveTouchButtonDelegate>
@property (nonatomic, strong) JSLAssistiveTouchButton *touchButton;
@property (nonatomic, strong) NSArray<NSString *> *touchButtonImages;
@end

@implementation JSLSafariViewController

#pragma mark -
#pragma mark 悬浮按钮图标数组（子类继承实现）
- (NSArray<NSString *> *)arrayOfAssistiveTouchButtonImages
{
    return @[ ICON_WEB_VIEW_BUTTON_CLEAR_CACHE,
              ICON_WEB_VIEW_BUTTON_RETURN_BACK,
              ICON_WEB_VIEW_BUTTON_REFRESH,
              ICON_WEB_VIEW_BUTTON_HOME];
}

#pragma mark -
#pragma mark 视图生命周期（初始化）
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark 视图生命周期（加载视图）
- (void)viewDidLoad
{
    [super viewDidLoad];

    WEAKSELF(weakSelf);
    
    // 辅助悬浮按钮
    {
        CGFloat touchBtnsize = FULL_SUSPEND_BALL_SIZE;
        CGRect frame = CGRectMake(APPINFORMATION.touchButtonOriginX.floatValue,
                                  APPINFORMATION.touchButtonOriginY.floatValue,
                                  touchBtnsize,
                                  touchBtnsize);
        JSLAssistiveTouchButton *touchButton  = [[JSLAssistiveTouchButton alloc] initWithFrame:frame];
        [self setTouchButton:touchButton];
        [self.view addSubview:touchButton];
        [self.view bringSubviewToFront:touchButton];
        
        [touchButton setDelegate:self];
        [touchButton setImages:self.touchButtonImages];
        [touchButton setRadius:touchBtnsize/2.0f];
        [touchButton setCanClickTempOn:YES]; // 开启背景遮幕
        [touchButton setWannaToClickTempDismiss:YES]; // 点击屏幕消失，需要设置canClickTempOn
        [touchButton setSpreadButtonOpenViscousity:YES]; // 开启粘滞功能
        [touchButton setWannaToScaleSpreadButtonEffect:NO];
        [touchButton setAutoAdjustToFitSubItemsPosition:YES];
        [touchButton setNormalImage:[UIImage imageNamed:ICON_WEB_VIEW_BUTTON_TOUCH_SETTING]];
        [touchButton setSelectImage:[UIImage imageNamed:ICON_WEB_VIEW_BUTTON_TOUCH_CLOSE]];
    }

    // 浏览器设置
    {
        // 事件处理Block
        [self.webView setHitTestEventBlock:^{
            [weakSelf.touchButton hitTestWithEventToShrinkCloseHandle];
        }];
        
        // 重置尺寸大小
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
}


#pragma mark 视图生命周期（加载视图）
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 调整适配悬浮按钮位置
    self.touchButton.x = APPINFORMATION.touchButtonOriginX.floatValue;
    self.touchButton.y = APPINFORMATION.touchButtonOriginY.floatValue;
}
    
#pragma mark 根据网址加载网页
- (void)startLoadRequestWithURL:(NSString *)url
{
    // 删除错误提示页面
    [self.webErrorView removeFromSuperview];
    [self setWebErrorView:nil];
    // 显示加载动画菊花
    [self.activityIndicatorView startAnimating];
    //
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:30.0f];
    [self.webView loadRequest:request];
}


#pragma mark -
#pragma mark JSLAssistiveTouchButtonDelegate
- (void)touchButton:(JSLAssistiveTouchButton *)touchButton didSelectedAtIndex:(NSUInteger)index withSelectedButton:(UIButton *)button
{
    if (self.touchButtonImages.count <= index) {
        return;
    }
    
    NSString *imageName = [self.touchButtonImages objectAtIndex:index];
    if ([ICON_WEB_VIEW_BUTTON_HOME isEqualToString:imageName]) {
        // 主页
        [self pressButtonWebViewHomeAction];
    } else if ([ICON_WEB_VIEW_BUTTON_REFRESH isEqualToString:imageName]) {
        // 刷新
        [self pressButtonWebViewErrorRefreshAction];
    } else if ([ICON_WEB_VIEW_BUTTON_RETURN_BACK isEqualToString:imageName]) {
        // 后退
        [self pressButtonWebViewGoBackAction];
    } else if ([ICON_WEB_VIEW_BUTTON_CLEAR_CACHE isEqualToString:imageName]) {
        // 清除缓存
        [self pressButtonWebViewCacheAction];
        [self.view makeToast:@"清除缓存成功" duration:1.0 position:CSToastPositionCenter];
    }
}

#pragma mark -
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark 设置导航条是否隐藏
- (BOOL)prefersNavigationBarHidden
{
    return YES;
}


#pragma mark -
#pragma mark Getter/Setter
- (NSArray<NSString *> *)touchButtonImages;
{
    if(!_touchButtonImages) {
        _touchButtonImages = [self arrayOfAssistiveTouchButtonImages];
    }
    return _touchButtonImages;
}


@end
