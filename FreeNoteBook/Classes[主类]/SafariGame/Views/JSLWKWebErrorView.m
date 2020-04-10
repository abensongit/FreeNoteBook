
#import "JSLWKWebErrorView.h"

@interface JSLWKWebErrorView ()
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *errorImageView;
@end

@implementation JSLWKWebErrorView

+ (instancetype)shareWKWebErrorView
{
    static JSLWKWebErrorView *_singetonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singetonInstance = [[super allocWithZone:NULL] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return _singetonInstance;
}

#pragma mark - 系统方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initViewControls];
        [self makeViewConstraints];
        [self maketapGestureRecognizer];
    }
    return self;
}

#pragma mark - 自定义方法
/** 添加控件 */
- (void)initViewControls
{
    self.backgroundColor = [UIColor colorFromHex:@"F2F2F2"];
    [self addSubview:self.infoLabel];
    [self addSubview:self.errorImageView];
}

/** 添加约束 */
- (void)makeViewConstraints
{
    CGFloat margin = JSL_AUTOSIZING_MARGIN(MARGIN);
    CGFloat errorImageSize = JSL_AUTOSIZING_WIDTH(250.0f);
    
    [self.errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0).with.offset(-errorImageSize*0.3f);
        make.size.mas_equalTo(CGSizeMake(errorImageSize, errorImageSize));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.errorImageView.mas_bottom).with.offset(margin*3.0f);
        make.centerX.mas_equalTo(0);
    }];
}

/** 添加点击手势 */
-(void)maketapGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorViewTapClickAction:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)errorViewTapClickAction:(UIGestureRecognizer *)tapRecognizer
{
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

#pragma mark - 懒Geter/Setter
- (UIImageView *)errorImageView
{
    if(!_errorImageView) {
        _errorImageView = [[UIImageView alloc] init];
        [_errorImageView setImage:[UIImage imageNamed:ICON_WEB_VIEW_ERROR_PICTURE]];
        [_errorImageView setUserInteractionEnabled:YES];
    }
    return _errorImageView;
}

- (UILabel *)infoLabel
{
    if(!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setText:@"出错啦，请点击图片刷新"];
        [_infoLabel setFont:[UIFont systemFontOfSize:JSL_AUTOSIZING_FONT(16.0f)]];
        [_infoLabel setTextColor:[UIColor colorFromHex:@"757575"]];
    }
    return _infoLabel;
}

@end
