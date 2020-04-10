
#import "JSLPlaceManager.h"

@interface JSLPlaceManager()

@property (nonatomic, strong) JSLPlaceHandler *handler;

@end

@implementation JSLPlaceManager

+ (instancetype)sharedManager
{
    static JSLPlaceManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchPlaceInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(JSLResultBlock)resultBlock
{
    [self.handler fetchPlaceInfosWithStartIndex:startIndex
                                      totalCount:totalCount
                                          result:resultBlock];
}


- (void)cachePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    [self.handler cachePlaceInfo:placeInfo result:resultBlock];
}


- (void)deletePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    [self.handler deletePlaceInfo:placeInfo result:resultBlock];
}


- (JSLPlaceHandler *)handler
{
    if (!_handler) {
        _handler = [[JSLPlaceHandler alloc] init];
    }
    
    return _handler;
}

@end
