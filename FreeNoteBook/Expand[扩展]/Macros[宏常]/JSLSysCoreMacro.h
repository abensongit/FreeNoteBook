

#ifndef _JSL_SYS_CORE_MACRO_H_
#define _JSL_SYS_CORE_MACRO_H_

#pragma mark -
#pragma mark 应用基本信息
#define APPINFORMATION                          [JSLSysUserDefaults standardUserDefaults]

#pragma mark -
#pragma mark 当前系统版本
#define APP_VERSION                             [JSLAppUtil getAppVersion]

#pragma mark -
#pragma mark 本地数据储存
#define NSUSERDEFAULTS_OBJECT_KEY(KEY)          [[NSUserDefaults standardUserDefaults] objectForKey:(KEY)]
#define NSUSERDEFAULTS_OBJECT_SET(VALUE,KEY)    [[NSUserDefaults standardUserDefaults] setObject:(VALUE) forKey:(KEY)];[[NSUserDefaults standardUserDefaults] synchronize]

#pragma mark -
#pragma mark 避免循环引用
#define WEAKTYPE(type) __weak __typeof(&*type)weak##type = type
#define WEAKSELF(weakSelf) __weak __typeof(&*self)weakSelf = self

#pragma mark -
#pragma mark 屏幕尺寸大小
#define SCREEN_SIZE              ([UIScreen mainScreen].bounds.size)
#define SCREEN_BOUNDS            ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH             ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT            ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_MAX_LENGTH        (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH        (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#pragma mark -
#pragma mark 机型判断
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0 && SCREEN_MIN_LENGTH == 320.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0 && SCREEN_MIN_LENGTH == 375.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0 && SCREEN_MIN_LENGTH == 414.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0 && SCREEN_MIN_LENGTH == 375.0)
#define IS_IPHONE_XR (IS_IPHONE && SCREEN_MAX_LENGTH == 896.0 && SCREEN_MIN_LENGTH == 414.0)
#define IS_IPHONE_XS (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0 && SCREEN_MIN_LENGTH == 375.0)
#define IS_IPHONE_XSMAX (IS_IPHONE && SCREEN_MAX_LENGTH == 896.0 && SCREEN_MIN_LENGTH == 414.0)
#define IS_IPHONE_X_OR_GREATER (IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XS || IS_IPHONE_XSMAX)


#pragma mark -
#pragma mark 应用程序尺寸
// APP_FRAME_WIDTH = SCREEN_WIDTH
#define APP_FRAME_WIDTH ([UIScreen mainScreen].applicationFrame.size.width)
// APP_FRAME_HEIGHT = SCREEN_HEIGHT-STATUSBAR_HEIGHT
// 注意：横屏（UIDeviceOrientationLandscape）时，iOS8默认隐藏状态栏，此时 APP_FRAME_HEIGHT = SCREEN_HEIGHT
#define APP_FRAME_HEIGHT ([UIScreen mainScreen].applicationFrame.size.height)

#pragma mark -
#pragma mark 不同机型宽度、高度、字体适配
// 字体进行适配
#define JSL_AUTOSIZING_FONT(fontSize)                             [JSLAutosizingUtil getAutosizeFontSize:(fontSize)]
#define JSL_AUTOSIZING_FONT_SCALE(fontSize)                       [JSLAutosizingUtil getAutosizeFontSizeScale:(fontSize)]
// 宽度进行适配
#define JSL_AUTOSIZING_WIDTH(width)                               [JSLAutosizingUtil getAutosizeViewWidth:(width)]
#define JSL_AUTOSIZING_WIDTH_SCALE(width)                         [JSLAutosizingUtil getAutosizeViewWidthScale:(width)]
// 高度进行适配
#define JSL_AUTOSIZING_HEIGTH(height)                             [JSLAutosizingUtil getAutosizeViewHeight:(height)]
#define JSL_AUTOSIZING_HEIGTH_SCALE(height)                       [JSLAutosizingUtil getAutosizeViewHeightScale:(height)]
// 间隔进行适配
#define JSL_AUTOSIZING_MARGIN(MARGIN)                             [JSLAutosizingUtil getAutosizeViewMargin:(MARGIN)]
#define JSL_AUTOSIZING_MARGIN_SCALE(MARGIN)                       [JSLAutosizingUtil getAutosizeViewMarginScale:(MARGIN)]


#pragma mark -
#pragma mark 颜色工具宏
#define COLOR_HEXSTRING(A)                                        [UIColor colorWithHexString:(A)]
#define COLOR_RGB(R, G, B)                                        [UIColor colorWithRed:((R)/255.f) green:((G)/255.f) blue:((B)/255.f) alpha:1.0f]
#define COLOR_RGBA(R, G, B, A)                                    [UIColor colorWithRed:((R)/255.f) green:((G)/255.f) blue:((B)/255.f) alpha:(A)]
#define COLOR_RANDOM                                              COLOR_RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0f)
#define COLOR_RANDOM_ALPHA(X)                                     COLOR_RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), (X))


#pragma mark -
#pragma mark 系统主题色 - 界面主色
#define COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT                        COLOR_HEXSTRING(@"#474747")
#pragma mark 系统主题色 - 界面底色 - 默认
#define COLOR_SYSTEM_MAIN_UI_BACKGROUND_DEFAULT                   COLOR_HEXSTRING(@"#EEEEF4")
#pragma mark 系统主题色 - 界面底色 - 前景 - 默认
#define COLOR_SYSTEM_MAIN_UI_BACKGROUND_FRONT_DEFAULT             COLOR_HEXSTRING(@"#FFFFFF")
#pragma mark 系统主题色 - 界面底色 - 背景 - 默认
#define COLOR_SYSTEM_MAIN_UI_BACKGROUND_BACK_DEFAULT              COLOR_HEXSTRING(@"#D8D9D8")
#pragma mark 系统主题色 - 主字体色 - 默认
#define COLOR_SYSTEM_MAIN_FONT_DEFAULT                            COLOR_HEXSTRING(@"#101010")
#pragma mark 系统主题色 - 辅助字体色 - 默认
#define COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT                     COLOR_HEXSTRING(@"#959595")
#pragma mark 系统主题色 - 按钮的颜色 - 正常 - 默认
#define COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_NORMAL_DEFAULT        COLOR_HEXSTRING(@"#FFFFFF")
#pragma mark 系统主题色 - 按钮的颜色 - 选中 - 默认
#define COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT        COLOR_HEXSTRING(@"#D64246")


#pragma mark -
#pragma mark 导航栏配置 - 背景颜色
#define COLOR_NAVIGATION_BAR_BACKGROUND_DEFAULT                   COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT
#pragma mark 导航栏配置 - 标题字体颜色
#define FONT_NAVIGATION_BAR_TITLE_DEFAULT                         [UIFont boldSystemFontOfSize:18.0]
#define COLOR_NAVIGATION_BAR_TITLE_DEFAULT                        COLOR_HEXSTRING(@"#FFFFFF")
#pragma mark 导航栏配置 - 按钮字体颜色
#define FONT_NAVIGATION_BAR_BUTTON_TITLE_DEFAULT                  [UIFont boldSystemFontOfSize:16.0f]
#define COLOR_NAVIGATION_BAR_BUTTON_TITLE_NORMAL_DEFAULT          COLOR_NAVIGATION_BAR_TITLE_DEFAULT
#define COLOR_NAVIGATION_BAR_BUTTON_TITLE_SELECT_DEFAULT          COLOR_NAVIGATION_BAR_TITLE_DEFAULT
#pragma mark 导航栏配置 - 底部横线颜色
#define COLOR_NAVIGATION_BAR_HAIR_LINE_DEFAULT                    COLOR_SYSTEM_MAIN_UI_BACKGROUND_BACK_DEFAULT


#pragma mark -
#pragma mark 标签栏配置 - 背景颜色
#define COLOR_TAB_BAR_BACKGROUND_DEFAULT                          COLOR_SYSTEM_MAIN_UI_BACKGROUND_BACK_DEFAULT
#pragma mark 标签栏配置 - 标题字体颜色
#define FONT_TAB_BAR_TITLE_DEFAULT                                [UIFont boldSystemFontOfSize:10.5f]
#define COLOR_TAB_BAR_TITLE_NORMAL_DEFAULT                        COLOR_HEXSTRING(@"#7A7C81")
#define COLOR_TAB_BAR_TITLE_SELECT_DEFAULT                        COLOR_HEXSTRING(@"#D64246")


#pragma mark -
#pragma mark UITableView表格背景色
#define COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT                    COLOR_SYSTEM_MAIN_UI_BACKGROUND_BACK_DEFAULT
#define COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT              COLOR_SYSTEM_MAIN_UI_BACKGROUND_BACK_DEFAULT
#define COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT            COLOR_SYSTEM_MAIN_UI_BACKGROUND_BACK_DEFAULT
#define COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT            COLOR_SYSTEM_MAIN_UI_BACKGROUND_BACK_DEFAULT


#pragma mark -
#pragma mark 刷新控件 - 背景颜色
#define COLOR_REFRESH_CONTROL_FRONT_DEFAULT                       COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT
#define COLOR_REFRESH_CONTROL_BACKGROUND_DEFAULT                  COLOR_HEXSTRING(@"#D6D6D6")


#pragma mark -
#pragma mark UIWebView - 进度条颜色
#define COLOR_UIWEBVIEW_PROGRESSVIEW_BACKGROUND                   COLOR_HEXSTRING(@"#1BB0E9")
#define COLOR_UIWEBVIEW_ACTIVITY_INDICATOR_BACKGROUND             COLOR_HEXSTRING(@"#F13031")


#endif /* _JSL_SYS_CORE_MACRO_H_ */
