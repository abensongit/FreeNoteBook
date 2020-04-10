
#import "JSLSettingHeaderView.h"

@interface JSLSettingHeaderView()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation JSLSettingHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImageView];
        __weak typeof(self) weakSelf = self;
        CGFloat imageSize = JSL_AUTOSIZING_WIDTH_SCALE(70.0f);
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(imageSize);
        }];
    }
    
    return self;
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        CGFloat imageSize = JSL_AUTOSIZING_WIDTH_SCALE(70.0f);
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = imageSize/2.0f;
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigHighDefinitionImage)];
        [_headImageView addGestureRecognizer:gesture];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.image = [UIImage imageNamed:ICON_HEAD_DEFAULT];
    }
    
    return _headImageView;
}


- (void)updateViewWithImage:(UIImage *)image
{
    if (image) {
        self.headImageView.image = image;
    }
}


- (void)showBigHighDefinitionImage
{
    if ([self.delegate respondsToSelector:@selector(showBigHighDefinitionImage)]) {
        [self.delegate showBigHighDefinitionImage];
    }
}

@end
