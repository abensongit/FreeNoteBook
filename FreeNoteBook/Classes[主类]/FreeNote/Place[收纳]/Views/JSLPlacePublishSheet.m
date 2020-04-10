
#import "JSLPlacePublishSheet.h"
#import "JSLTextField.h"

@interface JSLPlacePublishSheet()

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) JSLTextField *nameTextField;
@property (nonatomic, strong) JSLTextField *whereTextField;
@property (nonatomic, strong) UIButton    *cancelButton;
@property (nonatomic, strong) UIButton    *confirmButton;

@end

@implementation JSLPlacePublishSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    
    return self;
}

#pragma mark - Private

- (void)initUI
{
    [self.bgView addSubview:self.tapView];
    [self.contentView addSubview:self.nameTextField];
    __weak typeof(self) weakSelf = self;
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topMargin = STATUS_BAR_HEIGHT;
        if (IS_IPHONE_4_OR_LESS) {
            topMargin = STATUS_BAR_HEIGHT + 10.0f;
        } else if (IS_IPHONE_5) {
            topMargin = STATUS_BAR_HEIGHT + 15.0f;
        } else if (IS_IPHONE_6) {
            topMargin = STATUS_BAR_HEIGHT + 30.0f;
        } else if (IS_IPHONE_6P) {
            topMargin = STATUS_BAR_HEIGHT + 45.0f;
        } else if (IS_IPHONE_X || IS_IPHONE_XS) {
            topMargin = STATUS_BAR_HEIGHT + 15.0f;
        } else if (IS_IPHONE_XSMAX || IS_IPHONE_XR) {
            topMargin = STATUS_BAR_HEIGHT + 25.0f;
        }
        make.height.mas_equalTo(35);
        make.top.equalTo(weakSelf.contentView).with.offset(topMargin);
        make.left.equalTo(weakSelf.contentView).with.offset(30);
        make.right.equalTo(weakSelf.contentView).with.offset(-30);
    }];
    
    [self.contentView addSubview:self.whereTextField];
    
    [self.whereTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.equalTo(weakSelf.nameTextField.mas_bottom).with.offset(30);
        make.left.equalTo(weakSelf.contentView).with.offset(30);
        make.right.equalTo(weakSelf.contentView).with.offset(-30);
    }];
    
    [self.contentView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.left.equalTo(weakSelf.contentView).with.offset(20);
        make.bottom.equalTo(weakSelf.contentView).with.offset(-10);
    }];

    [self.contentView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(90);
        make.right.equalTo(weakSelf.contentView).with.offset(-5);
        make.bottom.equalTo(weakSelf.contentView).with.offset(20);
    }];
    
    [self.bgView addSubview:self.contentView];
}


- (void)cancel
{
    [self dismiss];
}


- (void)confirm
{
    if (self.nameTextField.textField.text.length == 0) {
        [JSLTips show:NSLocalizedString(@"请输入物品名称", nil)];
        return;
    }
    
    if (self.whereTextField.textField.text.length == 0) {
        [JSLTips show:NSLocalizedString(@"请输入物品放置位置", nil)];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(confirmWithPlaceInfo:)]) {
        JSLPlaceInfo *placeInfo = [[JSLPlaceInfo alloc] init];
        placeInfo.goodsName = self.nameTextField.textField.text;
        placeInfo.placeName = self.whereTextField.textField.text;
        [self.delegate confirmWithPlaceInfo:placeInfo];
    }
}

#pragma mark - Getter

- (UIView *)bgView
{
    if (!_bgView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _bgView = [[UIView alloc] initWithFrame:rect];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIView *)tapView
{
    if (!_tapView) {
        CGFloat height = IS_IPHONE_X_OR_GREATER ? JSL_AUTOSIZING_WIDTH_SCALE(220.0f) : JSL_AUTOSIZING_WIDTH_SCALE(220.0f);
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, height, rect.size.width, rect.size.height - height)];
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_tapView addGestureRecognizer:gesture];
    }
    
    return _tapView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat height = IS_IPHONE_X_OR_GREATER ? JSL_AUTOSIZING_WIDTH_SCALE(220.0f) : JSL_AUTOSIZING_WIDTH_SCALE(220.0f);
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, - height, rect.size.width, height)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
    }
    
    return _contentView;
}


- (JSLTextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[JSLTextField alloc] init];
        _nameTextField.ly_placeholder = NSLocalizedString(@"物品名称", nil);
        _nameTextField.placeholderSelectStateColor = UIColorFromHexRGB(0x7ABA00);
    }

    return _nameTextField;
}


- (JSLTextField *)whereTextField
{
    if (!_whereTextField) {
        _whereTextField = [[JSLTextField alloc] init];
        _whereTextField.ly_placeholder = NSLocalizedString(@"放哪里", nil);
        _whereTextField.placeholderSelectStateColor = UIColorFromHexRGB(0x7ABA00);
    }
    
    return _whereTextField;
}


- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_cancelButton setImage:[UIImage imageNamed:ICON_PLACE_PUBLISH_CANCLE]
                        forState:UIControlStateNormal];
        _cancelButton.contentMode = UIViewContentModeScaleToFill;
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}


- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 90)];
        [_confirmButton setImage:[UIImage imageNamed:ICON_PLACE_PUBLISH_CONFIRM]
                        forState:UIControlStateNormal];
        _confirmButton.contentMode = UIViewContentModeCenter;
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
    }

    return _confirmButton;
}

#pragma mark - Public

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:nil];
}


- (void)dismiss
{
    [self.nameTextField.textField resignFirstResponder];
    [self.whereTextField.textField resignFirstResponder];
    
    CGFloat height = IS_IPHONE_X_OR_GREATER ? JSL_AUTOSIZING_WIDTH_SCALE(220.0f) : JSL_AUTOSIZING_WIDTH_SCALE(220.0f);
    CGRect frame = self.contentView.frame;
    frame.origin.y = -height;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

@end
