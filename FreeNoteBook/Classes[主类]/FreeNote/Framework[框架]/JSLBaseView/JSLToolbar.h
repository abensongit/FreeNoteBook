
#import <UIKit/UIKit.h>

@protocol JSLToolbarDelegate <NSObject>

- (void)leftButtonAction;
- (void)rightButtonAction;

@end

@interface JSLToolbar : UIToolbar

@property (nonatomic, weak) id<JSLToolbarDelegate> toolbarDelegate;

- (instancetype)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle middleLabel:(NSString *)middleLabelStr rightButtonTitle:(NSString *)rightTitle;
- (instancetype)initWithFrame:(CGRect)frame leftView:(UIView *)left middleView:(UIView *)middle rightView:(UIView *)rightView;

@end
