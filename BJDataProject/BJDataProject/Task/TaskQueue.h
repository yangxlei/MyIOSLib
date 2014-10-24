//
//  TaskQueue.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-24.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaskQueue;
@protocol TaskQueueDelegate <NSObject>

/**
    任务队列执行完成, 只有在所有任务都成功执行完成才会调用
 */
- (void)taskQueueFinished:(TaskQueue *)taskQueue param:(id)param;

@end

@class TaskItem;
/**
 任务队列，能够依次执行队列中的各个任务；
 如果中间某个任务返回码错误，后面的任务都不会再执行
 */
@interface TaskQueue : NSObject

@property (nonatomic, weak) id<TaskQueueDelegate> delegate;
@property (nonatomic, strong) id param;

/**
 某个任务执行完成，由 TaskItem 调用
 */
- (void)ATaskItemFinished:(TaskItem *)taskItem error:(int)error;

- (void)addTaskItem:(TaskItem *)taskItem;

/**
 队列开始执行，在执行过程中任然可以添加任务
 */
- (void)start:(id)param;

- (void)CancelQueue;
@end
