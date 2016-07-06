//
//  DBManager.m
//  UserList
//
//  Created by mac on 14-12-30.
//  Copyright (c) 2014年 LaoWen. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager
{
    FMDatabase *_fmdb;
}



+ (DBManager *)sharedInstance
{
    static DBManager *instance;
    @synchronized(self){
        if (instance == nil){
            instance = [DBManager alloc];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"];
        NSLog(@"dbPath: %@", dbPath);
        _fmdb = [[FMDatabase alloc]initWithPath:dbPath];
        [_fmdb open];
        
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dbPath]];
        
      

        //建盒子数据表
        NSString *sql6 = @"create table if not exists box(ID integer primary key autoincrement,recordTime varchar(28),bloodVoice float,sync integer)";
        if (![_fmdb executeUpdate:sql6]) {
            NSLog(@"建表盒子数据失败:%@", _fmdb.lastErrorMessage);
        }else{
            NSLog(@"建表盒子数据成功");
        }
        

    } 
    return self;
}
-(void)dealloc
{
    [_fmdb close];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}



#pragma mark 按状态查询血糖
- (NSArray *)bloodVoiceAllUser:(NSInteger)sync
{
    
    NSString *sql = [NSString stringWithFormat:@"select * from box where sync=%ld",(long)sync];
    FMResultSet *resultSet = [_fmdb executeQuery:sql];
    NSMutableArray *result = [NSMutableArray array];
    while ([resultSet next]) {
        NNBoxModel *userModel = [[NNBoxModel alloc]init];
        userModel.sync = [resultSet intForColumn:@"sync"];//数据状态
        userModel.recordTime = [resultSet stringForColumn:@"recordTime"];//查询时间
        userModel.bloodGlucose =[resultSet doubleForColumn:@"bloodVoice"];//血糖值
        [result addObject:userModel];
    }
    
    return result;
    
}


#pragma mark 查询所有音频数据
- (NSArray *)boxVoiceAllUser
{
    NSString *sql = @"select * from box";
    FMResultSet *resultSet = [_fmdb executeQuery:sql];
    NSMutableArray *result = [NSMutableArray array];
    while ([resultSet next]) {
        NNBoxModel *userModel = [[NNBoxModel alloc]init];
        userModel.recordTime = [resultSet stringForColumn:@"recordTime"];//查询时间
        userModel.bloodVoice = [resultSet doubleForColumn:@"bloodVoice"];//血糖值
        userModel.sync = [resultSet intForColumn:@"sync"];//数据状态

//        userModel.boxSN= [resultSet stringForColumn:@"boxSN"];//盒子SN
//        userModel.xueTangYiSN=[resultSet stringForColumn:@"xueTangYiSN"];//血糖仪SN

       
        //        [result addObject:userModel];
        [result insertObject:userModel atIndex:0];
    }
    return result;
}


#pragma mark 新增盒子数据
/**
 *  新增盒子数据
 *
 *  @param userModel
 */
- (void)insertWithBloodVoiceModel:(NNBoxModel *)userModel
{
    NSLog(@"insertWithBloodGUserModel %@",userModel);
    NSLog(@"insertWith======userModel.sync %d",userModel.sync);
    NSLog(@"insertWith=====ync %@",[NSNumber numberWithInteger:userModel.sync]);

//    NSString *sql = @"insert into bloods(userID,sqlDate, sync, recordTime, eatState, bloodGlucose, memo,source,serveID) values(?, ?, ?, ?, ?, ?, ?, ?,?)";

    NSString *sql = @"insert into box(recordTime,bloodVoice,sync) values(?, ?, ?)";

    if (![_fmdb executeUpdate:sql,userModel.recordTime,[NSNumber numberWithFloat:userModel.bloodVoice],[NSNumber numberWithInteger:userModel.sync]]) {
        NSLog(@"插入盒子数据错误:%@", _fmdb.lastErrorMessage);
    }
    

}


#pragma mark 改血糖 音频盒子
/**
 *  改血糖 音频盒子
 *
 *  @param userModel
 */
- (void)updateWithBoxVoiceUserModel:(NNBoxModel *)userModel
{
    NSString *sql = @"update  box set sync=?, recordTime=?, bloodVoice=?";
//    NSString *sql = @"update  bloods set sync=?, recordTime=?, eatState=?, bloodGlucose=? ,memo=?, serveID=?  where id=?";
    BOOL ret = [_fmdb executeUpdate:sql,[NSNumber numberWithInteger:userModel.sync], userModel.recordTime,[NSNumber numberWithFloat:userModel.bloodVoice]];
    if (!ret) {
        NSLog(@"修改血糖失败:%@", _fmdb.lastErrorMessage);
    }else
    {
        NSLog(@"修改血糖成功");

    }
}


#pragma mark 删除音频里的血糖数据
    
-(void)deleteWhithBloodVoiceModel//
{
    
    
    NSString *sql = @"drop table box";
    BOOL ret = [_fmdb executeUpdate:sql];
    
    if (!ret) {
        NSLog(@"删除血糖失败:%@", _fmdb.lastErrorMessage);
    }else{
        NSLog(@"删除血糖表成功");
    }
    
    if ([_fmdb executeUpdate:@"vacuum"]) {//sqlite删除操作全部完成后，执行 VACUUM 命令。
        NSLog(@"置空血糖成功:%@",_fmdb.lastErrorMessage);
    }else{
        NSLog(@"置空血糖失败:%@",_fmdb.lastErrorMessage);
    }
    
    
}



@end
