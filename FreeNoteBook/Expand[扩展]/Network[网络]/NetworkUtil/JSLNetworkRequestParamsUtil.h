

#import <Foundation/Foundation.h>

#define JSL_PARAMS_NULL               @""
#define JSL_PARAMS_ZERO               @"0"
#define JSL_PARAMS_MAKE(PARAM)        [JSLNetworkRequestParamsUtil makeRequestParameters:PARAM]
#define JSL_PARAMS_NONNULL(PARAM)     [JSLNetworkRequestParamsUtil makeStringWithNoWhitespaceAndNewline:PARAM]

@interface JSLNetworkRequestParamsUtil : NSObject


#pragma mark -
#pragma mark 参数空白字符串处理
+ (NSString *)makeStringWithNoWhitespaceAndNewline:(NSString *)value;
#pragma mark 公共请求参数的处理
+ (NSMutableDictionary *)makeRequestParameters:(NSMutableDictionary *)params;


#pragma mark -
#pragma mark 网络接口 - 测试用例
+ (NSMutableDictionary *)getParametersForTest;


@end

