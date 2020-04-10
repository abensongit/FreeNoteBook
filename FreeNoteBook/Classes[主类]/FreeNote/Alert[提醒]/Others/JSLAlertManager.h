
#import <Foundation/Foundation.h>
#import "JSLAlertHandler.h"

static NSString *alertStateChangedNotification = @"alertStateChangedNotification";

@interface JSLAlertManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchAlertInfosWithResult:(JSLResultBlock)resultBlock;

- (void)cacheAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock;

- (void)updateAlertIsJoined:(BOOL)isJoined
                    alertId:(NSInteger)alertId
                     result:(void (^)(void))resultBlock;

- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock;

- (void)deleteAlertInfo:(JSLAlertInfo *)alertInfo result:(void (^)(void))resultBlock;


- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

@end
