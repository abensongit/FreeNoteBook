
#import "JSLMainMenuManager.h"

@interface JSLMainMenuManager()

@property (nonatomic, strong) JSLMainMenuHandler *handler;

@end

@implementation JSLMainMenuManager

+ (instancetype)sharedManager
{
    static JSLMainMenuManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });

    return _sManager;
}


- (void)fetchHeadInfoWithResultBlock:(JSLResultBlock)resultBlock
{
    [self.handler fetchHeadInfoWithResultBlock:resultBlock];
}


- (void)cacheHeadInfo:(JSLMainMenuHeadInfo *)headInfo
{
    [self.handler cacheHeadInfo:headInfo];
}


- (void)fetchConfigInfoWithResultBlock:(JSLResultBlock)resultBlock
{
    [self.handler fetchConfigInfoWithResultBlock:resultBlock];
}


- (void)cacheConfigInfo:(JSLAlertConfigInfo *)configInfo
{
    [self.handler cacheConfigInfo:configInfo];
}


- (JSLMainMenuHandler *)handler
{
    if (!_handler) {
        _handler = [[JSLMainMenuHandler alloc] init];
    }

    return _handler;
}

@end
