//
//  BJPerson.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJPerson.h"
#import "APITask.h"
#import "Common.h"

#define API_URL_PERSON  "/teacher_center/info"

@implementation BJPerson

- (instancetype)initWithPersonID:(long long)personId
{
    self = [super init];
    if (self)
    {
        _personID = personId;
        [self loadCache];
    }
    
    return self;
}

- (void)doRefreshOperation:(TaskQueue *)taskQueue
{
    if (_personID == 0)
        return;
    NSDictionary *postBody = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:_personID], @"user_id", nil];
    APITask *task = [[APITask alloc] initWithAPI:@API_URL_PERSON postBody:postBody];
    //TODO set task params
    [taskQueue addTaskItem:task];
}

- (void)setPersonID:(long long)personID
{
    if (_personID == personID && _taskQueue != nil)
    {// personID 没有改变，并且正在刷新. 可以直接返回
        return;
    }
    [self cancelRefresh];
    _personID = personID;
    [self loadCache];
}

- (NSString *)getCacheKey
{
    if (_personID != 0)
    {
        return [NSString stringWithFormat:@"person_%lld", _personID];
    }
    return nil;
}

@end
