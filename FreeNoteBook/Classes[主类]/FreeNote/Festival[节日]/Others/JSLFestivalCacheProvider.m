
#import "JSLFestivalCacheProvider.h"
#import "FMDB.h"

@implementation JSLFestivalCacheProvider

#pragma mark - Override

- (NSString *)name
{
    return @"freenote_festival_list";
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS freenote_festival_list ("
    @"bigDayId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    @"bigDayName             TEXT, "
    @"bigDayType             TEXT, "
    @"bigDayDate             TEXT, "
    @"bigDayRemark           TEXT "
    @");";
    
    BOOL result = [db executeUpdate:sql];
    return result;
}


#pragma mark - Public

- (NSArray<JSLFestivalInfo *> *)selectBigDayInfosFromStart:(NSInteger)startIndex
                                             totalCount:(NSInteger)totalCount
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        if (0 == startIndex) {
            result = [db executeQuery:@"SELECT * FROM freenote_festival_list ORDER BY bigDayId DESC LIMIT ? ", @(totalCount)];
        } else {
            result = [db executeQuery:@"SELECT * FROM freenote_festival_list where bigDayId < ? ORDER BY bigDayId DESC LIMIT ? ", @(startIndex), @(totalCount)];
        }
        
        while (result.next) {
            JSLFestivalInfo *dayInfo = [weakSelf buildBigDayInfoWithResult:result];
            [tmpArr addObject:dayInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (void)cacheBigDayInfo:(JSLFestivalInfo *)bigDayInfo
{
    if (nil == bigDayInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO "
         @"freenote_festival_list (bigDayId, bigDayName, bigDayType, bigDayDate, "
         @"bigDayRemark"
         @") "
    
         @"VALUES (?, ?, ?, ?, ?"
         @")",
         nil, bigDayInfo.bigDayName, bigDayInfo.bigDayType, bigDayInfo.bigDayDate,
         bigDayInfo.bigDayRemark];
        //插入成功后要更新内存中的节日id以便删除时使用
        if (success) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM freenote_festival_list ORDER BY bigDayId DESC LIMIT 1 "];
            while (result.next) {
                bigDayInfo.bigDayId = [[result stringForColumn:@"bigDayId"] integerValue];
            }
        }
    }];
}


- (void)deleteBigDayInfo:(JSLFestivalInfo *)bigDayInfo
{
    if (nil == bigDayInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM freenote_festival_list WHERE bigDayId = ?", @(bigDayInfo.bigDayId)];
    }];
}

#pragma mark - Private

- (JSLFestivalInfo *)buildBigDayInfoWithResult:(FMResultSet *)result
{
    JSLFestivalInfo *dayInfo = [[JSLFestivalInfo alloc] init];
    dayInfo.bigDayId = [[result stringForColumn:@"bigDayId"] integerValue];
    dayInfo.bigDayName = [result stringForColumn:@"bigDayName"];
    dayInfo.bigDayType = [result stringForColumn:@"bigDayType"];
    dayInfo.bigDayDate = [result stringForColumn:@"bigDayDate"];
    dayInfo.bigDayRemark = [result stringForColumn:@"bigDayRemark"];
    return dayInfo;
}

@end
