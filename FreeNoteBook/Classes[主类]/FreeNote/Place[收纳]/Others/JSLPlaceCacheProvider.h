
#import "JSLBaseDatabaseCommonProvider.h"
#import "JSLPlaceInfo.h"

@interface JSLPlaceCacheProvider : JSLBaseDatabaseCommonProvider

- (NSArray<JSLPlaceInfo *> *)selectPlaceInfosFromStart:(NSInteger)startIndex
                                           totalCount:(NSInteger)totalCount;

- (void)cachePlaceInfo:(JSLPlaceInfo *)placeInfo;

- (void)deletePlaceInfo:(JSLPlaceInfo *)placeInfo;

@end
