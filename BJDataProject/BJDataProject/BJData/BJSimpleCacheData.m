//
//  BJSimpleCacheData.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJSimpleCacheData.h"
#import "TaskItem.h"
#import "JsonUtils.h"
#include "CTime.h"


#define KEY_LAST_MODIFY @"last_modify"

/**
 *  用于检查缓存时间是否到期的任务, 单位秒
 */
@class BJSimpleCacheData;
@interface CheckCacheTimeTask : TaskItem
@property (nonatomic, weak) BJSimpleCacheData *simpleCacheData;;

@end

@implementation CheckCacheTimeTask

- (int)DoTask
{
    if (_simpleCacheData == nil)
    {
        [self TaskCompleted:BJ_ERROR_SUCCESSFULL result:nil];
        return 0;
    }
    
    long long lastModify = [_simpleCacheData.data longLongValueForKey:KEY_LAST_MODIFY defalutValue:0];
    long long current = bj_get_time();
    
    if (lastModify == 0 || (lastModify + [_simpleCacheData dataCacheTime]) < current)
    {
        [self TaskCompleted:BJ_ERROR_SUCCESSFULL result:nil];
    }
    else
    {
        [self TaskCompleted:BJ_ERROR_CANCEL result:nil];
    }
    
    return 0;
}


@end

@implementation BJSimpleCacheData

- (void)refresh
{
    if (_taskQueue != nil)
    { // 正在刷新，直接跳过
        return;
    }
    
    _taskQueue = [[TaskQueue alloc] init];
    
    // 先添加检查 cache time 的任务, 如果校验不通过，后面也都不会再执行了
    CheckCacheTimeTask *checkTask = [[CheckCacheTimeTask alloc] init];
    checkTask.simpleCacheData = self;
    [_taskQueue addTaskItem:checkTask];
    
    //子类去添加具体的任务
    [self doRefreshOperation:_taskQueue];
    
    _taskQueue.delegate = self;
    [_taskQueue start:nil];
}

- (void)saveCache
{
    [self.data setLongLongValue:bj_get_time() forKey:KEY_LAST_MODIFY];
    [super saveCache];
}

- (long)dataCacheTime
{
    return 0;
}

@end
