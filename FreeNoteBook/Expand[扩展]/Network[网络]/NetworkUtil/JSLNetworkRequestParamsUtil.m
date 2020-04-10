

#import "JSLNetworkRequestParamsUtil.h"


@implementation JSLNetworkRequestParamsUtil


#pragma mark -
#pragma mark 参数空白字符串处理
+ (NSString *)makeStringWithNoWhitespaceAndNewline:(NSString *)value
{
    // 非空判断
    if (nil == value
        || [@"NULL" isEqualToString:value]
        || [value isEqualToString:@"<null>"]
        || [value isEqualToString:@"(null)"]
        || [value isEqualToString:@"null"]) {
        return JSL_PARAMS_NULL;
    }
    // 删除两端的空格和回车
    NSString *contentString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return (nil == contentString || contentString.length == 0) ? JSL_PARAMS_NULL : contentString;
}

#pragma mark 公共请求参数的处理
+ (NSMutableDictionary *)makeRequestParameters:(NSMutableDictionary *)params
{
    NSMutableDictionary *PARAMETERS = @{
                                         @"jsl_param_test_00":JSL_PARAMS_NONNULL(@"JSL_PARAM_TEST_00")
                                       }.mutableCopy;
    if (params) {
        [PARAMETERS setValuesForKeysWithDictionary:params];
    }
    return PARAMETERS;
}


#pragma mark -
#pragma mark 网络接口 - 测试用例
+ (NSMutableDictionary *)getParametersForTest
{
    NSMutableDictionary *PARAMETERS = @{
                                        @"JSL_param_test_01":JSL_PARAMS_NONNULL(@"JSL_PARAM_TEST_01"),
                                        @"JSL_param_test_02":JSL_PARAMS_NONNULL(@"JSL_PARAM_TEST_02"),
                                        }.mutableCopy;
    return JSL_PARAMS_MAKE(PARAMETERS);
}



@end



