
#import "JSLBaseDatabaseCommonProvider.h"
#import "JSLAlertInfo.h"

@interface JSLAlertCacheProvider : JSLBaseDatabaseCommonProvider

- (NSArray<JSLAlertInfo *> *)selectAlertInfos;

- (NSArray<JSLAlertInfo *> *)selectUnJoinedAlertInfos;

- (JSLAlertInfo *)selectAlertInfoWithAlertId:(NSInteger)alertId;

- (void)cacheAlertInfo:(JSLAlertInfo *)alertInfo;

- (void)deleteAlertInfo:(JSLAlertInfo *)alertInfo;

- (void)updateAlertIsjoined:(BOOL)isJoined alertId:(NSInteger)alertId;

- (void)updateAlertIsFinishedWithAlertId:(NSInteger)alertId;

- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId;

- (void)autoCheckToMarkFinish;

@end
