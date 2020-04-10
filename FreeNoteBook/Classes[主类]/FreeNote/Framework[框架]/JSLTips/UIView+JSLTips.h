
#import <UIKit/UIKit.h>
#import "JSLLogoLoopView.h"

@interface UIView (JSLTips)

/**
 *  带文字的loading，黑底，不能穿透
 *
 */
- (void)showMaskLoadingTips:(NSString *)tips style:(JSLLogoLoopViewStyle)style;

- (void)showMultiLineMessage:(NSString *)message;

- (void)hideManualTips;

@end
