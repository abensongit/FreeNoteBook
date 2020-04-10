
#import "JSLSysUtil.h"

@implementation JSLSysUtil

#pragma mark -
#pragma mark 验证对象是否为空（数组、字典、字符串）
+ (BOOL)validateObjectIsNull:(id)obj
{
    if (nil == obj || obj == [NSNull null]) {
        return YES;
    }
    
    // 字典
    if ([obj isKindOfClass:[NSDictionary class]]) {
        
        if([obj isKindOfClass:[NSNull class]]) {
            return YES;
        }
    }
    // 数组
    else if ([obj isKindOfClass:[NSArray class]]) {
        
        if([obj isKindOfClass:[NSNull class]]) {
            return YES;
        }
    }
    // 字符串
    else if ([obj isKindOfClass:[NSString class]]) {
        
        return [JSLSysUtil validateStringEmpty:obj];
    }
    
    return NO;
}

#pragma mark 验证字符串是否为空
+ (BOOL)validateStringEmpty:(NSString *)value
{
    if (nil == value
        || [@"NULL" isEqualToString:value]
        || [value isEqualToString:@"<null>"]
        || [value isEqualToString:@"(null)"]
        || [value isEqualToString:@"null"]) {
        return YES;
    }
    // 删除两端的空格和回车
    NSString *str = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return (str.length <= 0);
}


#pragma mark -
#pragma mark 删除字符串两端的空格与回车
+ (NSString *)stringByTrimmingWhitespaceAndNewline:(NSString *)value
{
    if ([JSLSysUtil validateObjectIsNull:value]) {
        return @"";
    }
    
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#pragma mark -
#pragma mark 获取所有字体名称列表
+ (NSArray<NSString *> *)getAllFontFamilyNames
{
    NSMutableArray<NSString *> *fontNames = [NSMutableArray array];
    for(NSString *fontfamilyname in [UIFont familyNames]) {
        JSLLog(@"Family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname]) {
            [fontNames addObject:fontName];
            JSLLog(@"\tFont:'%@'",fontName);
        }
    }
    return [NSArray arrayWithArray:fontNames];
}


@end
