//
//  TeacherDetailInfo.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-28.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "TeacherDetailInfo.h"
#import "APITask.h"

#define GET_DATA_API @"/teacher_center/detailInfo"

@implementation TeacherDetailInfo

- (void)doRefreshOperation:(TaskQueue *)taskQueue
{
    APITask *task = [[APITask alloc] initWithAPI:GET_DATA_API postBody:nil];
    [taskQueue addTaskItem:task];
}

- (NSString *)getCacheKey
{
    return NSStringFromClass([self class]);
}

@end
