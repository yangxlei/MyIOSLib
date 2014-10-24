//
//  TaskQueue.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-24.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "TaskQueue.h"
#import "TaskItem.h"

@interface TaskQueue()
{
    NSMutableArray  *_queue;
    BOOL  b_start;
}

@end

@implementation TaskQueue

- (id)init
{
    self = [super init];
    if (self)
    {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)ATaskItemFinished:(TaskItem *)item error:(int)error
{
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

}

- (void)start:(id)param
{
    if (b_start) return;
    b_start = YES;
    _param = param;
    [self update];
}

- (void)CancelQueue
{
    if (b_start)
    {
        b_start = NO;
        _param = nil;
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

@end