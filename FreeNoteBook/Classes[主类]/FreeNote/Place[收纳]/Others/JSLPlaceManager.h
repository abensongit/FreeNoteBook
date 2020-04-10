
#import <Foundation/Foundation.h>
#import "JSLPlaceHandler.h"

@interface JSLPlaceManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchPlaceInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(JSLResultBlock)resultBlock;

- (void)cachePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock;

- (void)deletePlaceInfo:(JSLPlaceInfo *)placeInfo result:(void (^)(void))resultBlock;

@end
