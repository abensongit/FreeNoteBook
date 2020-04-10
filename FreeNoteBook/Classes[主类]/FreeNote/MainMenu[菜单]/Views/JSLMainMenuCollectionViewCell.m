
#import "JSLMainMenuCollectionViewCell.h"

@interface JSLMainMenuCollectionViewCell()

@property (nonatomic, strong) UILabel *menuLabel;

@end

@implementation JSLMainMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.menuLabel];
        
        __weak typeof(self) weakSelf = self;
        [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
    }

    return self;
}

- (UILabel *)menuLabel
{
    if (!_menuLabel) {
        _menuLabel = [[UILabel alloc] init];
        _menuLabel.textAlignment = NSTextAlignmentCenter;
        _menuLabel.textColor = [UIColor whiteColor];
        _menuLabel.font = [UIFont boldSystemFontOfSize:JSL_AUTOSIZING_FONT(18.0f)];
    }
    
    return _menuLabel;
}

- (void)updateCellWithTitle:(NSString *)title
{
    self.menuLabel.text = title;
    UIColor *bgColor;
    if ([title isEqualToString:STR_MAIN_MENU_ITEM_DIARIES]) {
        bgColor = UIColorFromHexRGB(0x5386EC);
    } else if ([title isEqualToString:STR_MAIN_MENU_ITEM_BILLS]) {
        bgColor = UIColorFromHexRGB(0xFD2B61);
    } else if ([title isEqualToString:STR_MAIN_MENU_ITEM_FESTIVAL]) {
        bgColor = UIColorFromHexRGB(0x43964E);
    } else if ([title isEqualToString:STR_MAIN_MENU_ITEM_PLACE]) {
        bgColor = UIColorFromHexRGB(0xFF8001);
    } else if ([title isEqualToString:STR_MAIN_MENU_ITEM_ALERT]) {
        bgColor = UIColorFromHexRGB(0xB01F00);
    } else if ([title isEqualToString:STR_MAIN_MENU_ITEM_SETTING]) {
        bgColor = UIColorFromHexRGB(0x9151EE);
    }
    
    self.contentView.backgroundColor = bgColor;
}


@end

