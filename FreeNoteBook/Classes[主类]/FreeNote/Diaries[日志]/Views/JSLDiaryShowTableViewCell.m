
#import "JSLDiaryShowTableViewCell.h"

@interface JSLDiaryShowTableViewCell()

@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation JSLDiaryShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.picImageView];
        __weak typeof(self) weakSelf = self;
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.right.equalTo(weakSelf.contentView).with.offset(-15);
            make.bottom.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}


- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.clipsToBounds = YES;
    }

    return _picImageView;
}


- (void)updateCellWithImage:(UIImage *)picImage
{
    self.picImageView.image = picImage;
}

@end
