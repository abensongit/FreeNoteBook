
#import "JSLBaseDataProvider.h"
#import "YYCache.h"

@interface JSLBaseLRUCacheProvider : JSLBaseDataProvider

@property (nonatomic, readonly) YYCache *yyCache;

- (instancetype)initWithName:(NSString *)name;

@end
