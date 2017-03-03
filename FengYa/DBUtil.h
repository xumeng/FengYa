//
//  DBUtil.h
//  FengYa
//
//  Created by Amon on 2017/3/3.
//  Copyright © 2017年 GodPlace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDBHelpers.h>

@interface DBUtil : NSObject

{
    DBUtil *dbhelper;
    FMDatabase *db;
    NSString *dbPath;
}

/**
 *  获取操作类实例
 *
 *  @return 操作类实例
 */
+(DBUtil *)sharedInstance;

/**
 *  打开数据库
 */
- (void)openDB;

/**
 *  关闭数据库
 */
- (void)closeDB;

- (int)selectCount;

- (NSMutableArray *) selectDataBy:(NSString *)cond;

- (NSMutableArray *) selectPoetryByIndex:(int)index;

@end
