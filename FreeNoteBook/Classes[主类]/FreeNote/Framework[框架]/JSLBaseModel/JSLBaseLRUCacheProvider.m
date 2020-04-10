
#import "JSLBaseLRUCacheProvider.h"
#import "JSLFileUtil.h"

@implementation JSLBaseLRUCacheProvider

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        if (name) {
            NSString *path = [[JSLFileUtil dataRootPath] stringByAppendingPathComponent:name];
            _yyCache = [[YYCache alloc] initWithPath:path];
        }
    }

    return self;
}


#pragma mark - Override

- (NSString *)name
{
    if (nil != _yyCache) {
        return _yyCache.name;
    }
    
    return NSStringFromClass([self class]);
}


- (NSInteger)version
{
    return 1;
}

@end
