//
//  BJFileManager.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BJUserAccount;
/**
    用于 data 中数据文件管理
 */
@interface BJFileManager : NSObject

/** 根据 data 中已设置好的 cache 获取全路径, 不包含 account */
+ (NSString *)getCacheFilePath:(NSString *)cache;

/**
    将对应的 cache 文件删除
 */
+ (void)deleteCacheFile:(NSString *)cache;

/**
 *  获取账户特定的 cache 文件
 *
 *  @param cache
 *  @param account
 *
 *  @return 
 */
+ (NSString *)getCacheFilePath:(NSString *)cache withAccount:(BJUserAccount *)account;

@end
