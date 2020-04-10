
#import "JSLThemeConfig.h"

@implementation JSLThemeConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navBarBGColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
        _navTintColor = COLOR_NAVIGATION_BAR_TITLE_DEFAULT;
        _mainBGColor = COLOR_SYSTEM_MAIN_UI_BACKGROUND_DEFAULT;
        _navTitleFont = FONT_NAVIGATION_BAR_TITLE_DEFAULT;
        _dividerColor = COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT;
    }
    
    return self;
}

#pragma mark - Public

+ (instancetype)currentTheme
{
    static JSLThemeConfig *_theme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theme = [[self alloc] init];
    });

    return _theme;
}

UIColor * UIColorFromHexARGB(CGFloat alpha, NSInteger hexRGB)
{
    return [UIColor colorWithRed:((float)((hexRGB & 0xFF0000) >> 16))/255.0
                           green:((float)((hexRGB & 0xFF00) >> 8))/255.0
                            blue:((float)(hexRGB & 0xFF))/255.0
                           alpha:alpha];
}

UIColor * UIColorFromHexRGB(NSInteger hexRGB)
{
    return UIColorFromHexARGB(1, hexRGB);
}

@end
