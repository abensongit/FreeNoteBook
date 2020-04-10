
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSLWKWebErrorViewBlock)(void);

@interface JSLWKWebErrorView : UIView

@property (nonatomic, copy) JSLWKWebErrorViewBlock refreshBlock;

+ (instancetype)shareWKWebErrorView;

@end

NS_ASSUME_NONNULL_END
