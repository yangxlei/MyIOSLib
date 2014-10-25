//
//  BJFileManager.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    用于 data 中数据文件管理
 */
@interface BJFileManager : NSObject

/** 根据 data 中已设置好的 cache 获取全路径 */
+ (NSString *)getCacheFilePath:(NSString *)cache;

/**
    将对应的 cache 文件删除
 */
+ (void)deleteCacheFile:(NSString *)cache;

@end
