
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JSLLogoLoopViewStyle) {
    kLogoLoopGray,
    kLogoLoopWhite,
};

@interface JSLLogoLoopView : UIView

- (instancetype)initWithStyle:(JSLLogoLoopViewStyle)style;

- (void)startAnimating;

@end
