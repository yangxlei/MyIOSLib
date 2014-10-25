//
//  TaskQueue.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-24.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "TaskQueue.h"
#import "TaskItem.h"
#import "BJData.h"

@interface TaskQueue()
{
    NSMutableArray  *_queue;
    BOOL  b_start;
}

@end

@implementation TaskQueue

- (void)dealloc
{
    [_queue removeAllObjects];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _queue = [[NSMutableArray alloc] init];
        b_start = NO;
    }
    return self;
}

- (void)ATaskItemFinished:(TaskItem *)item error:(int)error result:(id)result
{
    if (item.taskStatus == TASK_STATUS_DOING)
    {
        if ([item.delegate respondsToSelector:@selector(taskDidFinished:)])
        {
            [item.delegate taskDidFinished:item];
        }
        
        if (error == ERROR_SUCCESSFULL)
        {
            item.taskStatus = TASK_STATUS_FINISH;
            _result = result;
        }
        
        if (item.taskStatus == TASK_STATUS_FINISH)
        {
            [self update];
        }
        else
        {
            [self cancelQueue];
            if([_delegate respondsToSelector:@selector(taskQueueFinished:param:error:)])
            {
                [_delegate taskQueueFinished:self param:_param error:error];
                _param = nil;
                _result = nil;
            }
        }
    }
}

- (void)addTaskItem:(TaskItem *)taskItem
{
    if (! taskItem) return;
    [_queue addObject:taskItem];
    if (b_start)
    {
        [self update];
    }
}

/**
    更新队列
 */
- (void)update
{
    BOOL bCompleted = NO;
    for (NSUInteger index = 0; index < [_queue count]; ++ index)
    {
        TaskItem *item = [_queue objectAtIndex:index];
        if (item.taskStatus == TASK_STATUS_WAIT)
        {
            item.taskStatus = TASK_STATUS_DOING;
            item.param = _param;
            item.taskQueue = self;
            if ([item.delegate respondsToSelector:@selector(taskWillStart:)])
            {
                [item.delegate taskWillStart:item];
            }
            
            item.taskId = [item DoTask];
            
            if ([item.delegate respondsToSelector:@selector(taskDidStart:)] && item.taskStatus == TASK_STATUS_DOING)
            {
                [item.delegate taskDidStart:item];
            }
            break;
        }
    }
    
    bCompleted = YES;
    for (TaskItem *item in _queue)
    {
        if (item.taskStatus != TASK_STATUS_FINISH)
        {
            bCompleted = NO;
            break;
        }
    }
    
   if (bCompleted && b_start)
   {
       b_start = NO;
       if ([_delegate respondsToSelector:@selector(taskQueueFinished:param:error:)])
       {
           [_delegate taskQueueFinished:self param:_param error:ERROR_SUCCESSFULL];
           _result = nil;
       }
       _param = nil;
   }
}

- (void)start:(id)param
{
    if (b_start) return;
    b_start = YES;
    _param = param;
    [self update];
}

- (void)cancelQueue
{
    if (b_start)
    {
        b_start = NO;
        _param = nil;
        _result = nil;
        for (TaskItem *item in _queue)
        {
            if (item.taskStatus == TASK_STATUS_DOING)
            {
                item.taskStatus = TASK_STATUS_WAIT;
                [item CancelTask];
                item.taskId = 0;
                item.taskQueue = nil;
            }
        }
    }
}

- (void)cleanQueue
{
    [self cancelQueue];
    for (TaskItem *item in _queue)
    {
        if (item.taskStatus == TASK_STATUS_DOING)
        {
            [item CancelTask];
            item.taskId = 0;
        }
        
        item.delegate = nil;
        item.taskQueue = nil;
    }
    _delegate = nil;
    _param = nil;
    _result = nil;
}

@end