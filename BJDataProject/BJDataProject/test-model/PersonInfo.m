//
//  PersonInfo.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "PersonInfo.h"
#import "APITask.h"

#define GET_DATA_API @"/user/info"

@implementation PersonInfo

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
    APITask *task = [[APITask alloc] initWithAPI:GET_DATA_API postBody:nil];
    [taskQueue addTaskItem:task];
}

- (NSString *)getCacheKey
{
    return NSStringFromClass([self class]);
}

@end
