
#import "JSLFestivalManager.h"

@interface JSLFestivalManager()

@property (nonatomic, strong) JSLFestivalHandler *handler;

@end

@implementation JSLFestivalManager

+ (instancetype)sharedManager
{
    static JSLFestivalManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchBigDayInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(JSLResultBlock)resultBlock
{
    [self.handler fetchBigDayInfosWithStartIndex:startIndex
                                      totalCount:totalCount
                                          result:resultBlock];
}


- (void)cacheBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    [self.handler cacheBigDayInfo:bigDayInfo result:resultBlock];
}


- (void)deleteBigDayInfo:(JSLFestivalInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    [self.handler deleteBigDayInfo:bigDayInfo result:resultBlock];
}


- (JSLFestivalHandler *)handler
{
    if (!_handler) {
        _handler = [[JSLFestivalHandler alloc] init];
    }
    
    return _handler;
}

@end
