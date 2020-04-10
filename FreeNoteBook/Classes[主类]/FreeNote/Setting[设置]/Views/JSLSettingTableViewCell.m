
#import "JSLSettingTableViewCell.h"

@interface JSLSettingTableViewCell()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView  *bottomView;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation JSLSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self.contentView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(17);
            make.width.height.mas_equalTo(15);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.right.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
        
        [self.contentView addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.width.height.mas_equalTo(20);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.equalTo(weakSelf.contentView).with.offset(42);
            make.right.equalTo(weakSelf.arrowImageView.mas_left).offset(-20);
            make.centerY.equalTo(weakSelf.contentView);
        }];
    }

    return self;
}


- (void)updateCellWithTitle:(NSString *)title
{
    self.itemLabel.text = title;
    self.bottomView.hidden = [title isEqualToString:STR_SETTING_MENU_ITEM_COMMENT];
    if ([title isEqualToString:STR_SETTING_MENU_ITEM_HEAD]) {
        self.picImageView.image = [UIImage imageNamed:ICON_SETTING_HEAD];
    } else if ([title isEqualToString:STR_SETTING_MENU_ITEM_ABOUT]) {
        self.picImageView.image = [UIImage imageNamed:ICON_SETTING_ABOUT];
    } else if ([title isEqualToString:STR_SETTING_MENU_ITEM_COMMENT]) {
        self.picImageView.image = [UIImage imageNamed:ICON_SETTING_PRAISE];
    }
}

#pragma mark Getter

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = [UIFont systemFontOfSize:JSL_AUTOSIZING_FONT_SCALE(15.0f)];
        _itemLabel.textColor = UIColorFromHexRGB(0x666666);
    }
    
    return _itemLabel;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [JSLThemeConfig currentTheme].dividerColor;
    }

    return _bottomView;
}


- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.image = [UIImage imageNamed:ICON_ARROW_RIGHT];
    }

    return _arrowImageView;
}


- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _picImageView;
}

@end
