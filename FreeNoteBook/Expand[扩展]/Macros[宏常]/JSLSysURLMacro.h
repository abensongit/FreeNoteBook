

#ifndef _JSL_SYS_URL_MACRO_H_
#define _JSL_SYS_URL_MACRO_H_


#pragma mark -
#pragma mark 系统接口
#define URL_API_APPENDING(URL)              [JSLHTTPSessionManager makeRequestWithBaseURLString:URL_API_BASE URLString:URL]


#pragma mark -
#pragma mark 生产环境
#define URL_API_BASE                                         @"http://cfapi.app/main/cf55"


#pragma mark -
#pragma mark 默认网络
#define URL_DEFAULT_NETWORK_ABAILABLE                        @"https://www.google.com"


#pragma mark -
#define URL_API_TEST                                         URL_API_APPENDING(@"cm/f_c_getGamePlay")




#endif /* _JSL_SYS_URL_MACRO_H_ */






