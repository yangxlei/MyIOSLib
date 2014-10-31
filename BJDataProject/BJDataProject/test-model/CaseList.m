//
//  CaseList.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "CaseList.h"
#import "APITask.h"

#define REFRESH_API @"/teacher_center/caseList"

@implementation CaseList

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
    APITask *task = [[APITask alloc] initWithAPI:REFRESH_API postBody:nil];
    [taskQueue addTaskItem:task];
}

- (NSString *)getCacheKey
{
    return @"case_list";
}

- (BOOL)messageHandle:(NSString *)message params:(id)params
{
    NSLog(@"message %@   params  %@", message, params);
    return NO;
}

@end
