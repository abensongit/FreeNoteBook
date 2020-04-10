
#import <UIKit/UIKit.h>

@class EMProgressInfo;
static CGFloat defaultWidth = 38;

@interface JSLProgressLoopView : UIView 

@property (nonatomic, strong) EMProgressInfo *progressInfo;

@property (nonatomic, strong) UIColor *baseTrackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progress;//0~1之间的数
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, strong) UIImage *defaultImage;

+ (instancetype)defaultProgressLoopView;


@end
