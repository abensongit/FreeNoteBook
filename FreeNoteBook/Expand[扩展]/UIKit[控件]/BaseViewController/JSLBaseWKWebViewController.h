
#import <WebKit/WebKit.h>
#import "JSLBaseCommonViewController.h"
#import "WebViewJavascriptBridge.h"


@interface JSLBaseWKWebViewController : JSLBaseCommonViewController

@property (nonatomic, copy) NSString *htmlUrlString;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;

@property (nonatomic, assign) BOOL hasShowCloseButton;
@property (nonatomic, strong) UIButton *closeButton;

#pragma mark 事件处理 - 刷新
- (void)pressButtonWebViewRefreshAction;
#pragma mark 事件处理 - 后退
- (void)pressButtonWebViewGoBackAction;
#pragma mark 事件处理 - 前进
- (void)pressButtonWebViewGoForwardAction;
#pragma mark 事件处理 - 关闭
- (void)pressButtonWebViewCloseAction;

#pragma mark 初始化 - 网络
- (instancetype)initWithHTMLUrlString:(NSString *)htmlUrlString;
#pragma mark 初始化 - 本地
- (instancetype)initWithLocalHTMLString:(NSString *)htmlUrlString;

#pragma mark JS与OC处理交互
- (void)webViewJavascriptBridgeRegisterHandler;

@end
