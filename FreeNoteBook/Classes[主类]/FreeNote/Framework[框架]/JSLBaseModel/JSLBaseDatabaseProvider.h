
#import "JSLBaseDataProvider.h"
#import "JSLDataBase.h"

//接口表示子类需要重写的
@protocol JSLBaseDatabaseProvider <JSLBaseDataProvider>

/**
 *  创建表
 *  @return  是否创建成功
 */
- (BOOL)onCreateTable:(FMDatabase *)db;


/**
 *  更新表
 *  @return 是否更新成功
 */
- (BOOL)onUpgradeTable:(FMDatabase *)db fromVersion:(NSInteger)fromVersion toVersion:(NSInteger)toVersion;

@end

@interface JSLBaseDatabaseProvider : JSLBaseDataProvider <JSLBaseDatabaseProvider>

@property (nonatomic, readonly) FMDatabaseQueue * dbQueue;

/**
 * 根据database进行建表
 *
 */
- (void)buildTable:(JSLDatabase *)database;

@end
