
#import "UIView+JSLTips.h"

@implementation UIView (JSLTips)

- (void)showMaskLoadingTips:(NSString *)tips style:(JSLLogoLoopViewStyle)style
{
    JSLLogoLoopView *loopView = [[JSLLogoLoopView alloc] initWithStyle:style];
    [loopView setFrame:CGRectMake(0, 0, 200, 200)];
    [JSLTips showLoading:loopView message:tips inView:self interaction:NO];
    [loopView startAnimating];
}

- (void)showMultiLineMessage:(NSString *)message
{
    [JSLTips showTitle:nil message:message inView:self duration:2 complete:nil];
}

- (void)hideManualTips
{
    JSLTipsView *currTips = [JSLTips sharedTips].manualTipsView;
    if ([currTips currentSuperview] == self) {
        [JSLTips hideTips];
    }
}

@end
