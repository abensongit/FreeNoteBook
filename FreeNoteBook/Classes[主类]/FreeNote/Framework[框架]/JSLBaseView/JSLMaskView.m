
#import "JSLMaskView.h"

@interface JSLMaskView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JSLMaskView

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
}

- (UIView *)bgView
{
    if (!_bgView) {
        // 背景
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        _bgView = [[UIView alloc] initWithFrame:window.bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.64];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_bgView.bounds];
        
        CGFloat x = window.bounds.size.width - NAVIGATION_BAR_BUTTON_MAX_WIDTH / 2.0f;
        CGFloat y = NAVIGATION_BAR_HEIGHT / 2.0f + STATUS_BAR_HEIGHT;
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y)
                                                                  radius:18
                                                              startAngle:0
                                                                endAngle:2 * M_PI
                                                               clockwise:NO];
        [path appendPath:circlePath];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        _bgView.layer.mask = shapeLayer;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:gesture];
        
        //
        CGFloat imageWidth = _bgView.frame.size.width*0.8f;
        CGFloat imageHeight = imageWidth*0.644f;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
        _imageView.image = [UIImage imageNamed:ICON_MASK_VIEW];
        _imageView.userInteractionEnabled = YES;
        [_bgView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_bgView.mas_centerX);
            make.top.equalTo(self->_bgView.mas_top).offset(STATUS_NAVIGATION_BAR_HEIGHT*1.5f);
            make.size.mas_equalTo(CGSizeMake(imageWidth, imageHeight));
        }];
    }

    return _bgView;
}

- (void)dismiss
{
    [self.bgView removeFromSuperview];
}

@end
