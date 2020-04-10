
#import <Foundation/Foundation.h>

@interface JSLFileUtil : NSObject

//应用Documents所在目录
+ (NSString *)documentsPath;

//保存应用数据的根目录
+ (NSString *)dataRootPath;

@end
