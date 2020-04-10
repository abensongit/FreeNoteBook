

#import <Foundation/Foundation.h>


/** 缓存的Block */
typedef void(^HttpRequestCache)(id responseCache);
/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error);
/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);


@interface JSLNetworkHTTPSessionUtil : NSObject

/**
 *  网络管理单例
 */
+ (instancetype)sharedHTTPSessionManager;


#pragma mark -
#pragma mark 请求地址参数工具
/**
 *  封装请求链接API（自定义前缀）
 *
 *  @param baseUrlString  链接前缀字符串
 *  @param urlString      链接后缀字符串
 *
 *  @return 返回请求链接地址
 */
+ (NSString *)makeRequestWithBaseURLString:(NSString *)baseUrlString URLString:(NSString *)urlString;
/**
 *  封装请求参数
 *
 *  @return 返回请求参数
 */
+ (NSMutableDictionary *)makeRequestParamerterWithKeys:(NSArray<NSString *> *)keys Values:(NSArray *)values;


#pragma mark -
#pragma mark GET请求网络方式
/**
 *  GET请求（菊花）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（菊花、提示）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（菊花、提示、异常）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 *  @param isHideErrorMessage   是否显示提示信息
 */
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD isHideErrorMessage:(BOOL)isHideErrorMessage;

/**
 *  GET请求（缓存、菊花）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（缓存、菊花、提示）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（缓存、菊花、提示、异常）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 *  @param isHideErrorMessage   是否显示异常信息
 */
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD isHideErrorMessage:(BOOL)isHideErrorMessage;


#pragma mark -
#pragma mark POST请求网络方式
/**
 *  GET请求（菊花）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（菊花、提示）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（菊花、提示、异常）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 *  @param isHideErrorMessage   是否显示提示信息
 */
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD isHideErrorMessage:(BOOL)isHideErrorMessage;

/**
 *  GET请求（缓存、菊花）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（缓存、菊花、提示）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 */
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD;

/**
 *  GET请求（缓存、菊花、提示、异常）
 *
 *  @param url                  请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *  @param showMessage          加载菊花提示信息
 *  @param isShowProgressHUD    是否显示加载菊花
 *  @param isHideErrorMessage   是否显示异常信息
 */
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure showMessage:(NSString *)showMessage showProgressHUD:(BOOL)isShowProgressHUD isHideErrorMessage:(BOOL)isHideErrorMessage;


@end



