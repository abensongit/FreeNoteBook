
#import "JSLLaunchViewController.h"
#import "JSLMainMenuViewController.h"
#import "JSLBaseNavigationController.h"

@interface JSLLaunchViewController ()

@property (nonatomic, strong) UIImageView *launcherImageView;

@end


@implementation JSLLaunchViewController

#pragma mark -
#pragma mark 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark 设置导航条是否隐藏
- (BOOL)prefersNavigationBarHidden
{
   return YES;
}

#pragma mark -
#pragma mark 视图生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewDidLoadMainUI];
    
    WEAKSELF(weakSelf);
    __block NSInteger timeOut = 2.5f;
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 启动图显示后操作处理
                [weakSelf showMainMenuViewController];
            });
        } else {
            timeOut--;
        }
    });
    dispatch_resume(timer);
}

- (void)viewDidLoadMainUI
{
    self.view.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.launcherImageView];
}

- (void)showMainMenuViewController
{
    JSLMainMenuViewController *vc = [[JSLMainMenuViewController alloc] init];
    JSLBaseNavigationController *nav = [[JSLBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.launcherImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.launcherImageView removeFromSuperview];
    }];
}

#pragma mark - Getter/Setter

- (UIImageView *)launcherImageView
{
    if (!_launcherImageView) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        _launcherImageView = [[UIImageView alloc] initWithFrame:mainWindow.bounds];
        _launcherImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _launcherImageView.image = [self launchImageUrl];
    }

    return _launcherImageView;
}

- (UIImage *)launchImageUrl
{
    UIImage *image = [UIImage imageNamed:@"icon_launcher_image_375667"];
    
    if (IS_IPHONE_4_OR_LESS) {
        image = [UIImage imageNamed:@"icon_launcher_image_320480"];
    } else if (IS_IPHONE_5) {
        image = [UIImage imageNamed:@"icon_launcher_image_320568"];
    } else if (IS_IPHONE_6) {
        image = [UIImage imageNamed:@"icon_launcher_image_375667"];
    } else if (IS_IPHONE_6P) {
        image = [UIImage imageNamed:@"icon_launcher_image_414736"];
    } else if (IS_IPHONE_XS) {
        image = [UIImage imageNamed:@"icon_launcher_image_375812"];
    } else if (IS_IPHONE_XSMAX) {
        image = [UIImage imageNamed:@"icon_launcher_image_414896"];
    }
    return image;
}

@end
