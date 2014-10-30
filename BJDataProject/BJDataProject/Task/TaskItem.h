//
//  TaskItem.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-24.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TaskQueue.h"

enum _task_status
{
    TASK_STATUS_WAIT,
    TASK_STATUS_DOING,
    TASK_STATUS_FINISH
}TASKSTATUS;

@class TaskItem;
@protocol TaskItemDelegate <NSObject>

- (void)taskWillStart:(TaskItem *)taskItem;
- (void)taskDidStart:(TaskItem *)taskItem;
- (void)taskDidFinished:(TaskItem *)taskItem;

@end

/**
 任务队列中的某一项任务
 */
@interface TaskItem : NSObject

@property (nonatomic, weak) TaskQueue *taskQueue;

/**
 任务状态监听代理，由 taskQueue 调用
 */
@property (nonatomic, weak) id<TaskItemDelegate> delegate;

/** 当前任务ID */
@property (nonatomic, assign) NSInteger taskId;

/** 当前任务状态, 由 TaskQueue 更改 */
@property (nonatomic, assign) int taskStatus;

/** 结果返回码， 只有任务执行完成才能有值 */
@property (nonatomic, assign, readonly) int resultError;

/** 任务执行过程中的全局参数, 存在于 TaskQueue */
@property (nonatomic, weak) id param;

/**
    任务开始执行
    @result 返回任务ID
 */
- (int)DoTask;

/**
    取消任务执行
 */
- (void)CancelTask;

/**
    任务完成，在本类中调用
 */
- (void)TaskCompleted:(int)error result:(id)result;
@end
