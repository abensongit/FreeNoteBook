
#import "JSLAlertCacheProvider.h"
#import "FMDB.h"

@implementation JSLAlertCacheProvider

#pragma mark - Override

- (NSString *)name
{
    return @"freenote_alert_list";
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS freenote_alert_list ("
    @"alertId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    @"alertName              TEXT, "
    @"alertRepeatType        INTEGER, "
    @"alertDate              DATE, "
    @"alertRemark            TEXT, "
    @"joinLocalNotification  INTEGER DEFAULT 0, "
    @"isFinish               INTEGER DEFAULT 0, "
    @"isComplete             INTEGER DEFAULT 0 "
    @");";
    
    BOOL result = [db executeUpdate:sql];
    return result;
}


#pragma mark - Public

- (NSArray<JSLAlertInfo *> *)selectAlertInfos
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        result = [db executeQuery:@"SELECT * FROM freenote_alert_list ORDER BY alertId DESC"];

        while (result.next) {
            JSLAlertInfo *alertInfo = [weakSelf buildAlertInfoWithResult:result];
            [tmpArr addObject:alertInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (NSArray<JSLAlertInfo *> *)selectUnJoinedAlertInfos
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        result = [db executeQuery:@"SELECT * FROM freenote_alert_list WHERE joinLocalNotification = 0 ORDER BY alertDate ASC"];
        
        while (result.next) {
            JSLAlertInfo *alertInfo = [weakSelf buildAlertInfoWithResult:result];
            [tmpArr addObject:alertInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (JSLAlertInfo *)selectAlertInfoWithAlertId:(NSInteger)alertId
{
    __block JSLAlertInfo *alertInfo = nil;
    __weak typeof(self) weakSelf = self;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        result = [db executeQuery:@"SELECT * FROM freenote_alert_list WHERE alertId = ?", @(alertId)];
        while (result.next) {
            alertInfo = [weakSelf buildAlertInfoWithResult:result];
        }
        
        [result close];
    }];
    
    return alertInfo;
}


- (void)cacheAlertInfo:(JSLAlertInfo *)alertInfo
{
    if (nil == alertInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO "
         @"freenote_alert_list (alertId, alertName, alertRepeatType, alertDate, "
         @"alertRemark, joinLocalNotification, isFinish, isComplete"
         @") "
    
         @"VALUES (?, ?, ?, ?, ?, ?, ?, ?"
         @")",
         nil, alertInfo.alertName, @(alertInfo.alertRepeatType), alertInfo.alertDate, alertInfo.alertRemark, @(alertInfo.joinLocalNotification), @(alertInfo.isFinish), @(alertInfo.isComplete)];
        //插入成功后要更新内存中的提醒id以便删除、更新时使用
        if (success) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM freenote_alert_list ORDER BY alertId DESC LIMIT 1 "];
            while (result.next) {
                alertInfo.alertId = [[result stringForColumn:@"alertId"] integerValue];
            }
        }
    }];
}


- (void)updateAlertIsjoined:(BOOL)isJoined alertId:(NSInteger)alertId;
{
    if (0 == alertId) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE freenote_alert_list SET joinLocalNotification = ? WHERE alertId = ?", @(isJoined), @(alertId)];
    }];
}


- (void)updateAlertIsFinishedWithAlertId:(NSInteger)alertId
{
    if (0 == alertId) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE freenote_alert_list SET isFinish = 1 WHERE alertId = ?", @(alertId)];
    }];
}


- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
{
    if (0 == alertId) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE freenote_alert_list SET isComplete = 1 WHERE alertId = ?", @(alertId)];
    }];
}


- (void)deleteAlertInfo:(JSLAlertInfo *)alertInfo
{
    if (nil == alertInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM freenote_alert_list WHERE alertId = ?", @(alertInfo.alertId)];
    }];
}


- (void)autoCheckToMarkFinish
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        result = [db executeQuery:@"SELECT * FROM freenote_alert_list WHERE isFinish = 0"];
        
        while (result.next) {
            JSLAlertInfo *alertInfo = [weakSelf buildAlertInfoWithResult:result];
            NSDate *nowDate = [NSDate date];
            if (alertInfo.alertRepeatType == kJSLAlertRepeatTypeNever && alertInfo.alertDate <= nowDate) {
                [tmpArr addObject:alertInfo];
            }
        }
        [result close];
    }];
    
    
    for (JSLAlertInfo *alertInfo in tmpArr) {
        [self updateAlertIsFinishedWithAlertId:alertInfo.alertId];
    }
}

#pragma mark - Private

- (JSLAlertInfo *)buildAlertInfoWithResult:(FMResultSet *)result
{
    JSLAlertInfo *alertInfo = [[JSLAlertInfo alloc] init];
    alertInfo.alertId = [[result stringForColumn:@"alertId"] integerValue];
    alertInfo.alertName = [result stringForColumn:@"alertName"];
    alertInfo.alertRepeatType = [[result stringForColumn:@"alertRepeatType"] integerValue];
    alertInfo.alertDate = [result dateForColumn:@"alertDate"];
    alertInfo.alertRemark = [result stringForColumn:@"alertRemark"];
    alertInfo.joinLocalNotification = [result boolForColumn:@"joinLocalNotification"];
    alertInfo.isFinish = [result boolForColumn:@"isFinish"];
    alertInfo.isComplete = [result boolForColumn:@"isComplete"];
    return alertInfo;
}

@end
