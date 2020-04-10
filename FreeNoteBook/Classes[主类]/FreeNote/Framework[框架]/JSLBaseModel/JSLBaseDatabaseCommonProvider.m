
#import "JSLBaseDatabaseCommonProvider.h"
#import "JSLFileUtil.h"

@interface JSLBaseDatabaseCommonProvider()

@property (nonatomic, strong) JSLDatabase *database;

@end

@implementation JSLBaseDatabaseCommonProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        _database = [[self class] getDefaultDatabase];
        [self buildTable:_database];
    }
    
    return self;
}


#pragma mark - Override

- (FMDatabaseQueue *)dbQueue
{
    return self.database.dbQueue;
}


#pragma mark - Class

+ (JSLDatabase *)getDefaultDatabase
{
    static JSLDatabase *sDatabase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * dbPath = [[JSLFileUtil dataRootPath] stringByAppendingPathComponent:@"freenote.dat"];
        sDatabase = [[JSLDatabase alloc] initWithDBPath:dbPath];
        sDatabase.tag = @"common";
    });
    
    return sDatabase;
}

@end
