//
//  TaskItem.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-24.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "TaskItem.h"

@implementation TaskItem

- (int)DoTask
{
    return 0;
}

- (void)CancelTask
{
}


- (void)TaskCompleted:(int)error result:(id)result
{
    _resultError = error;
    
    [_taskQueue ATaskItemFinished:self error:_resultError result:result];
    _delegate = nil;
    _taskQueue = nil;
}
@end
