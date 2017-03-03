//
//  DBUtil.m
//  FengYa
//
//  Created by Amon on 2017/3/3.
//  Copyright © 2017年 GodPlace. All rights reserved.
//

#import "DBUtil.h"

static NSString const *kPoetryDBName = @"all_sqlite";
static NSString const *kPoetryTableName = @"t_poetry";


@implementation DBUtil

- (int)selectCount
{
    NSString *countSql = [NSString stringWithFormat:@"select count(*) from %@", kPoetryTableName];
    FMResultSet *rs = [db executeQuery:countSql];
    int count = 0;
    while ([rs next]) {
        count =[rs intForColumnIndex:0];
    }
    return count;
}

- (NSMutableArray *) selectPoetryByIndex:(int)index
{
    return [self selectDataBy:[NSString stringWithFormat:@"d_num = %i", index]];
}

- (NSMutableArray *) selectDataBy:(NSString *)cond
{
    if (cond == nil || cond.length < 1) {
        cond = @" 1=1 ";
    }
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT d_poetry, d_author, d_intro, d_title, d_num FROM %@ where %@ ",kPoetryTableName, cond];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[rs stringForColumn:@"d_poetry"] forKey:@"poetry"];
            [dict setValue:[rs stringForColumn:@"d_author"] forKey:@"author"];
            [dict setValue:[rs stringForColumn:@"d_intro"] forKey:@"intro"];
            [dict setValue:[rs stringForColumn:@"d_title"] forKey:@"title"];
            [dict setValue:[rs stringForColumn:@"d_num"] forKey:@"index"];
            [resultList addObject:dict];
        }
    }
    return resultList;
}

- (void)openDB
{
    if (!dbPath) {
        dbPath = [[NSBundle mainBundle] pathForResource:kPoetryDBName ofType:@"db"];
    }
    
    //获取数据库并打开
    db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Open database failed");
        return ;
    }
}
- (void)closeDB
{
    [db close];
}



static DBUtil * instance = nil;

+ (DBUtil *)sharedInstance
{
    @synchronized(self) {
        if ( instance == nil ) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}


@end
