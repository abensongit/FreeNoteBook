
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^JSLWKWebViewHitTestEventBlock)(void);

@interface JSLWKWebView : WKWebView

@property (nonatomic, copy) JSLWKWebViewHitTestEventBlock hitTestEventBlock;

@end

NS_ASSUME_NONNULL_END
