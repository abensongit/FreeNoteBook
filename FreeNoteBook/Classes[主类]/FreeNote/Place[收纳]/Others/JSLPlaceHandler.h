
#import "JSLBaseHandler.h"
#import "JSLPlaceCacheProvider.h"

@interface JSLPlaceHandler : JSLBaseHandler

- (void)fetchPlaceInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(JSLResultBlock)resultBlock;

- (void)cachePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock;

- (void)deletePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock;

@end
