//
//  BJPerson.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJPerson.h"
#import "APITask.h"

#define API_URL_PERSON  "/teacher_center/info?&auth_token="

@implementation BJPerson

- (void)doRefreshOperation:(TaskQueue *)taskQueue
{
    APITask *task = [[APITask alloc] init];
    //TODO set task params
    [taskQueue addTaskItem:task];
}

@end
