//
//  DBManager.m
//  LimitFreeProject
//


#import "DBManager.h"
#import "ArticleModel.h"

NSString * const kLZXFavorite = @"favorites";
NSString * const kLZXDownloads = @"downloads";
NSString * const kLZXBrowses = @"browese";

/*
 数据库
 1.导入 libsqlite3.dylib
 2.导入 fmdb
 3.导入头文件
 fmdb 是对底层C语言的sqlite3的封装
 
 */
@implementation DBManager
{
    //数据库对象
    FMDatabase *_database;
}
//非标准单例
+ (DBManager *)sharedManager {
    static DBManager *manager = nil;
    @synchronized(self) {//同步 执行 防止多线程操作
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        NSString *filePath = [self getFileFullPathWithFileName:@"book.db"];
        //2.创建database
        _database = [[FMDatabase alloc] initWithPath:filePath];
        //3.open
        //第一次 数据库文件如果不存在那么 会创建并且打开
        //如果存在 那么直接打开
        if ([_database open]) {
            NSLog(@"数据库打开成功");
            //创建表 不存在 则创建
            [self creatTable];
        }else {
            NSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
}
#pragma mark - 创建表
- (void)creatTable {
    //字段: 应用名 应用id 当前价格 最后价格 icon地址 记录类型 价格类型
    NSString *sql = @"create table if not exists appInfo(serial integer  Primary Key Autoincrement,appName Varchar(1024),appId Varchar(1024),author Varchar(1024),comment Varchar(1024),icon Varchar(1024),recordType Varchar(1024),appType Varchar(1024))";
    NSString *sql2 = @"create table if not exists KeyWordInfo(serial integer Primary Key Autoincrement,keyword Varchar(1024),recordType Varchar(1024))";
    //创建表 如果不存在则创建新的表
    BOOL isSuccees1 = [_database executeUpdate:sql];
    if (!isSuccees1) {
        NSLog(@"creatTable1 error:%@",_database.lastErrorMessage);
    }
    BOOL isSuccees2 = [_database executeUpdate:sql2];
    if (!isSuccees2) {
        NSLog(@"creatTable2 error:%@",_database.lastErrorMessage);
    }
}
#pragma mark - 获取文件的全路径

//获取文件在沙盒中的 Documents中的路径
- (NSString *)getFileFullPathWithFileName:(NSString *)fileName {
    NSString *docPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents"];
    NSLog(@"----%@",docPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {
        //文件的全路径
        return [docPath stringByAppendingFormat:@"/%@",fileName];
    }else {
        //如果不存在可以创建一个新的
        NSLog(@"Documents不存在");
        return nil;
    }
}


//增加 数据 收藏/浏览/下载记录
//存储类型 favorites downloads browses
- (void)insertModel:(id)model recordType:(NSString *)type {
    
    ArticleModel *appModel = (ArticleModel *)model;
    NSString *bookID =[NSString stringWithFormat:@"%ld",appModel.bookid];
    if ([self isExistAppForAppId:bookID recordType:type]) {
        NSLog(@"this app has  recorded");
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"insert into appInfo(appName,appId,author,comment,icon,recordType,appType) values ('%@',%ld,'%@','%@','%@','%@','%@')",appModel.book_name,appModel.bookid,appModel.author,appModel.comment,appModel.icon,type,appModel.type];
 BOOL isSuccess = [_database executeUpdate:sql];
    
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }else{
        NSLog(@"插入成功");
    }
}

//删除指定的应用数据 根据指定的类型
- (void)deleteModelForAppId:(NSString *)appId recordType:(NSString *)type {
    NSString *sql = @"delete from appInfo where appId = ? and recordType = ?";
    BOOL isSuccess = [_database executeUpdate:sql,appId,type];
    if (!isSuccess) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}

//根据指定类型  查找所有的记录
//根据记录类型 查找 指定的记录
- (NSArray *)readModelsWithRecordType:(NSString *)type{
    
    NSString *sql = @"select * from appInfo where recordType = ?";
    FMResultSet * rs = [_database executeQuery:sql,type];

    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([rs next]) {
        //把查询之后结果 放在model
        ArticleModel *appModel = [[ArticleModel alloc] init];
        appModel.book_name= [rs stringForColumn:@"appName"];
        
        appModel.bookid = [rs stringForColumn:@"appId"];
        appModel.author = [rs stringForColumn:@"author"];
        appModel.comment = [rs stringForColumn:@"comment"];
        appModel.icon = [rs stringForColumn:@"icon"];
        appModel.type = [rs stringForColumn:@"appType"];
        //放入数组
        [arr addObject:appModel];
    }
    return arr;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForAppId:(NSString *)appId recordType:(NSString *)type {
    NSString *sql = @"select * from appInfo where appId = ? and recordType = ?";
    FMResultSet *rs = [_database executeQuery:sql,appId,type];
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type {
    NSString *sql = @"select count(*) from appInfo where recordType = ?";
    FMResultSet *rs = [_database executeQuery:sql,type];
    NSInteger count = 0;
    while ([rs next]) {
        //查找 指定类型的记录条数
        count = [[rs stringForColumnIndex:0] integerValue];
    }
    return count;
}
//搜索历史
- (void)insertKeyWord:(NSString *)keyword recordType:(NSString *)type{
    if ([self isExistKeyWord:keyword recordType:type]) {
        NSLog(@"");
        return;
    }
    NSString *sql = @"insert into KeyWordInfo(keyword,recordType) values (?,?)";
    BOOL isSuccess = [_database executeUpdate:sql,keyword,type];
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
}
- (void)deleteKeyWord:(NSString *)keyword recordType:(NSString *)type{
    NSString *sql = @"delete from KeyWordInfo where keyword = ? and recordType = ?";
    BOOL isSuccess = [_database executeUpdate:sql,keyword,type];
}
- (NSArray *)readKeyWordsWithRecordType:(NSString *)type{
    NSString *sql = @"select * from KeyWordInfo where recordType = ?";
    FMResultSet *rs = [_database executeQuery:sql,type];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next]) {
        NSString *keyword = [rs stringForColumn:@"keyword"];
        [arr addObject:keyword];
    }
    return arr;
}
- (BOOL)isExistKeyWord:(NSString *)keyword recordType:(NSString *)type{
    NSString *sql = @"select * from KeyWordInfo where keyword = ? and recordType = ?";
    FMResultSet *rs = [_database executeQuery:sql,keyword,type];
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
@end
