
#import "JSLLogoLoopView.h"

@interface JSLLogoLoopView ()

@property (nonatomic, strong) CALayer   *loopLayer;

@end


@implementation JSLLogoLoopView

- (instancetype)initWithStyle:(JSLLogoLoopViewStyle)style
{
    self = [super init];
    if (self) {
        [self setup:style];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:kLogoLoopGray];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.loopLayer.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
}


- (void)setup:(JSLLogoLoopViewStyle)style
{
    NSString *imageName = @"icon_loading_loop";
    if (style == kLogoLoopWhite) {
        imageName = @"icon_loading_loop_white";
    }
    
    UIImage *loopImage = [UIImage imageNamed:imageName];
    self.loopLayer.frame = (CGRect){CGPointZero, CGSizeMake(loopImage.size.width*2.0f, loopImage.size.height*2.0f)};
    self.loopLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self.layer addSublayer:self.loopLayer];
    self.loopLayer.contents = (__bridge id _Nullable)(loopImage.CGImage);
}

- (void)startAnimating
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = 1;
    rotation.fromValue = @0;
    rotation.toValue = @(2 * M_PI);
    rotation.repeatCount = MAXFLOAT;
    rotation.removedOnCompletion = NO;
    [self.loopLayer addAnimation:rotation forKey:@"transform.rotation"];
}

- (CALayer *)loopLayer
{
    if (!_loopLayer) {
        _loopLayer = [CALayer layer];
    }
    return _loopLayer;
}

@end
