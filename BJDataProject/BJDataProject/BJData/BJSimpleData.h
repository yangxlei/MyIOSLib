//
//  BJSimpleData.h
//  BJDataProject
//
//  Created by 杨磊 on 14-9-19.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJData.h"
#import "TaskQueue.h"

@class BJSimpleData;
typedef void (^simpleDataOperationCallback)(BJSimpleData *simpleData, int error, int ope, id result);

/**
 *  使用 Dictionary 的数据类型w 
 */
@interface BJSimpleData : BJData<TaskQueueDelegate>
{
    TaskQueue *_taskQueue;
}

/**
  当前 BJData 的 json 数据
 */
@property (nonatomic, strong) NSMutableDictionary *data;

/**
    开启刷新数据操作
 */
- (void)refresh;

- (void)refresh:(simpleDataOperationCallback)operationCallback;

/**
 *  取消刷新操作
 */
- (void)cancelRefresh;

/**
    执行刷新，由子类实现; 具体怎么刷新由子类决定，父类只执行一个刷新操作的队列 
 */
- (void)doRefreshOperation:(TaskQueue *)taskQueue;

@end
