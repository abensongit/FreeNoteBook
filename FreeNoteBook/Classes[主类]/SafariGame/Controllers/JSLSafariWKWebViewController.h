
#import <WebKit/WebKit.h>
#import "JSLWKWebView.h"
#import "JSLBaseCommonViewController.h"
#import "WebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLSafariWKWebViewController : JSLBaseCommonViewController

@property (nonatomic, copy) NSString *htmlUrlString;
@property (nonatomic, strong) JSLWKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) JSLProgressView *progressView;
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;

@property (nonatomic, assign) BOOL hasShowCloseButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong, nullable) JSLWKWebErrorView *webErrorView;
@property (nonatomic, strong, nullable) DGActivityIndicatorView *activityIndicatorView;

#pragma mark 事件处理 - 主页
- (void)pressButtonWebViewHomeAction;
#pragma mark 事件处理 - 刷新
- (void)pressButtonWebViewRefreshAction;
#pragma mark 事件处理 - 后退
- (void)pressButtonWebViewGoBackAction;
#pragma mark 事件处理 - 前进
- (void)pressButtonWebViewGoForwardAction;
#pragma mark 事件处理 - 关闭
- (void)pressButtonWebViewCloseAction;
#pragma mark 事件处理 - 缓存
- (void)pressButtonWebViewCacheAction;
#pragma mark 事件处理 - 错误
- (void)pressButtonWebViewErrorRefreshAction;

#pragma mark 初始化 - 网络
- (instancetype)initWithHTMLUrlString:(NSString *)htmlUrlString;
#pragma mark 初始化 - 本地
- (instancetype)initWithLocalHTMLString:(NSString *)htmlUrlString;

#pragma mark JS与OC处理交互
- (void)webViewJavascriptBridgeRegisterHandler;

#pragma mark 请求刷新网址（子类继承）
- (NSString *)webViewLoadRequestURLStrring;
#pragma mark 根据网址加载网页
- (void)webViewStartLoadRequest;

#pragma mark -
#pragma mark 请求网络地址数据
- (void)requestNetworkURLStringDataThen:(void (^)(BOOL success, JSLSafariUrlModel *safariUrlModel))then;


@end

NS_ASSUME_NONNULL_END
