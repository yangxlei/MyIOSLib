//
//  SubjectData.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "SubjectData.h"
#import "APITask.h"

#define GET_DATA_API @"/subject/getAllData"

@implementation SubjectData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadCache];
    }
    return self;
}

- (void)dealloc
{
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

- (long)dataCacheTime
{
    return 100000;
}
@end
