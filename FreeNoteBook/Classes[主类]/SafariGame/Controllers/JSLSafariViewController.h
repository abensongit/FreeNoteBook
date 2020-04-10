
#import "JSLSafariWKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLSafariViewController : JSLSafariWKWebViewController

#pragma mark 悬浮按钮图标（子类继承实现）
- (NSArray<NSString *> *)arrayOfAssistiveTouchButtonImages;

#pragma mark 根据网址加载网页
- (void)startLoadRequestWithURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
