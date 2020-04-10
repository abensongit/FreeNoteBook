
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLSysUtil : NSObject

#pragma mark -
#pragma mark 验证对象是否为空（数组、字典、字符串）
+ (BOOL)validateObjectIsNull:(id)obj;
#pragma mark 验证字符串是否为空
+ (BOOL)validateStringEmpty:(NSString *)value;

#pragma mark -
#pragma mark 删除字符串两端的空格与回车
+ (NSString *)stringByTrimmingWhitespaceAndNewline:(NSString *)value;

#pragma mark -
#pragma mark 获取所有字体名称列表
+ (NSArray<NSString *> *)getAllFontFamilyNames;

@end

NS_ASSUME_NONNULL_END
