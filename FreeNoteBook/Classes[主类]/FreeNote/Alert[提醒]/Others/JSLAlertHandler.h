
#import "JSLBaseHandler.h"
#import "JSLAlertCacheProvider.h"

@interface JSLAlertHandler : JSLBaseHandler

- (void)fetchAlertInfosWithResult:(JSLResultBlock)resultBlock;

- (void)fetchUnJoinedAlertInfosWithResult:(JSLResultBlock)resultBlock;

- (void)selectAlertInfoWithAlertId:(NSInteger)alertId result:(JSLResultBlock)resultBlock;

- (void)cacheAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock;

- (void)updateAlertIsJoined:(BOOL)isJoined
                    alertId:(NSInteger)alertId
                     result:(void (^)(void))resultBlock;

- (void)updateAlertIsFinishedwithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock;

- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock;

- (void)deleteAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock;


- (void)autoCheckToMarkFinish;

@end
