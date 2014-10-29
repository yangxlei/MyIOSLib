//
//  LessonList.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "LessonList.h"
#import "APITask.h"

#define REFRESH_API @"/user/info"

@implementation LessonList

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        [self loadCache];
    }
    return self;
}

- (void)doRefreshOperation:(TaskQueue *)taskQueue
{
    APITask *task = [[APITask alloc] initWithAPI:REFRESH_API postBody:nil];
    [taskQueue addTaskItem:task];
}

//- (void)doGetMoreOperation:(TaskQueue *)taskQueue
//{
//}
//
//- (void)doAddItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index
//{
//}
//
//- (void)doRemoveItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index
//{
//}
//
//- (void)doSaveItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index
//{
//}

- (NSString *)getCacheKey
{
    return NSStringFromClass([self class]);
}

@end
