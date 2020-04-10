

#import "JSLNetworkHTTPSessionUtil.h"
#import "YTKBaseRequest+AnimatingAccessory.h"
#import "JSLBaseRequest.h"


@interface JSLNetworkHTTPSessionUtil ()

@end


@implementation JSLNetworkHTTPSessionUtil


#pragma mark -
#pragma mark 网络管理单例
+ (instancetype)sharedHTTPSessionManager
{
    static JSLNetworkHTTPSessionUtil *_singetonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (nil == _singetonInstance) {
            // 网络请求管理单例
            _singetonInstance = [[super allocWithZone:NULL] init];
        }
    });
    return _singetonInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedHTTPSessionManager];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedHTTPSessionManager];
}


#pragma mark -
#pragma mark 封装请求地址
+ (NSString *)makeRequestWithBaseURLString:(NSString *)baseUrlString URLString:(NSString *)urlString
{
    return [NSString stringWithFormat:@"%@%@", baseUrlString, urlString];
}

#pragma mark 封装请求参数
+ (NSMutableDictionary *)makeRequestParamerterWithKeys:(NSArray<NSString *> *)keys Values:(NSArray *)values
{
    NSMutableDictionary *paramerter = [NSMutableDictionary dictionary];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramerter setObject:values[idx] forKey:key];
    }];
    return paramerter;
}


#pragma mark -
#pragma mark GET请求（菊花）
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] GET:url parameters:parameters responseCache:nil success:success failure:failure showMessage:nil showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark GET请求（菊花、提示）
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] GET:url parameters:parameters responseCache:nil success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark GET请求（菊花、提示、异常）
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD  isHideErrorMessage:(BOOL)isHideErrorMessage
{
    [[self class] GET:url parameters:parameters responseCache:nil success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:isHideErrorMessage];
}

#pragma mark GET请求（缓存、菊花）
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] GET:url parameters:parameters responseCache:responseCache success:success failure:failure showMessage:nil showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark GET请求（缓存、菊花、提示）
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] GET:url parameters:parameters responseCache:responseCache success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark GET请求（缓存、菊花、提示、异常）
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD isHideErrorMessage:(BOOL)isHideErrorMessage
{
    [[self class] requestWithUrl:url parameters:parameters method:JSLRequestMethodGET responseCache:responseCache success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}


#pragma mark -
#pragma mark POST请求（菊花）
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] POST:url parameters:parameters responseCache:nil success:success failure:failure showMessage:nil showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark POST请求（菊花、提示）
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] POST:url parameters:parameters responseCache:nil success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark POST请求（菊花、提示、异常）
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD  isHideErrorMessage:(BOOL)isHideErrorMessage
{
    [[self class] POST:url parameters:parameters responseCache:nil success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:isHideErrorMessage];
}

#pragma mark POST请求（缓存、菊花）
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] POST:url parameters:parameters responseCache:responseCache success:success failure:failure showMessage:nil showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark POST请求（缓存、菊花、提示）
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD
{
    [[self class] POST:url parameters:parameters responseCache:responseCache success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}

#pragma mark POST请求（缓存、菊花、提示、异常）
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD isHideErrorMessage:(BOOL)isHideErrorMessage
{
    [[self class] requestWithUrl:url parameters:parameters method:JSLRequestMethodPOST responseCache:responseCache success:success failure:failure showMessage:showMessage showProgressHUD:isShowProgressHUD isHideErrorMessage:NO];
}


#pragma mark -
#pragma mark 公共请求方法
+ (void)requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters method:(JSLRequestMethod)method responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD isHideErrorMessage:(BOOL)isHideErrorMessage
{
    // 设置联网指示器的可见性
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 网络请求类
    JSLBaseRequest *requestSession = [[JSLBaseRequest alloc] init];
    requestSession.url = url;
    requestSession.parameters = parameters;
    requestSession.method = method;
    requestSession.isHideErrorMessage = isHideErrorMessage;
    requestSession.animatingText = isShowProgressHUD ? ( showMessage.length > 0 ? showMessage : @"" ) : nil;
    
    // 获取缓存数据
    if (responseCache && [requestSession loadCacheWithError:nil]) {
        responseCache ? responseCache(requestSession.responseJSONObject) : nil;
    }
    
    // 请求最新数据
    [requestSession startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        // 设置联网指示器的可见性
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // 请求数据成功后操作处理
        success ? success(request.responseJSONObject) : nil;
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        // 设置联网指示器的可见性
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // 请求数据失败后操作处理
        failure ? failure(request.error): nil;
        
        JSLLog(@"ERROR = [ %@ ]", request.error);
        
    }];
}


@end

