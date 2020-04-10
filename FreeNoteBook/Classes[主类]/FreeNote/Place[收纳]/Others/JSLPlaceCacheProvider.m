
#import "JSLPlaceCacheProvider.h"
#import "FMDB.h"

@implementation JSLPlaceCacheProvider

#pragma mark - Override

- (NSString *)name
{
    return @"freenote_place_list";
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS freenote_place_list ("
    @"placeId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    @"placeName              TEXT, "
    @"goodsName              TEXT "
    @");";
    
    BOOL result = [db executeUpdate:sql];
    return result;
}


#pragma mark - Public

- (NSArray<JSLPlaceInfo *> *)selectPlaceInfosFromStart:(NSInteger)startIndex
                                           totalCount:(NSInteger)totalCount
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        if (0 == startIndex) {
            result = [db executeQuery:@"SELECT * FROM freenote_place_list ORDER BY placeId DESC LIMIT ? ", @(totalCount)];
        } else {
            result = [db executeQuery:@"SELECT * FROM freenote_place_list where placeId < ? ORDER BY placeId DESC LIMIT ? ", @(startIndex), @(totalCount)];
        }
        
        while (result.next) {
            JSLPlaceInfo *placeInfo = [weakSelf buildPlaceInfoWithResult:result];
            [tmpArr addObject:placeInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (void)cachePlaceInfo:(JSLPlaceInfo *)placeInfo
{
    if (nil == placeInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO "
         @"freenote_place_list (placeId, placeName, goodsName"
         @") "
    
         @"VALUES (?, ?, ?"
         @")",
         nil, placeInfo.placeName, placeInfo.goodsName];
        //插入成功后要更新内存中的placeId以便删除时使用
        if (success) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM freenote_place_list ORDER BY placeId DESC LIMIT 1 "];
            while (result.next) {
                placeInfo.placeId = [[result stringForColumn:@"placeId"] integerValue];
            }
        }
    }];
}


- (void)deletePlaceInfo:(JSLPlaceInfo *)placeInfo
{
    if (nil == placeInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM freenote_place_list WHERE placeId = ?", @(placeInfo.placeId)];
    }];
}

#pragma mark - Private

- (JSLPlaceInfo *)buildPlaceInfoWithResult:(FMResultSet *)result
{
    JSLPlaceInfo *placeInfo = [[JSLPlaceInfo alloc] init];
    placeInfo.placeId = [[result stringForColumn:@"placeId"] integerValue];
    placeInfo.placeName = [result stringForColumn:@"placeName"];
    placeInfo.goodsName = [result stringForColumn:@"goodsName"];
    return placeInfo;
}

@end
