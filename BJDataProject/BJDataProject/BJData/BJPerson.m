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

#define API_URL_PERSON  "/teacher_center/info?&auth_token="

@implementation BJPerson

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
    [self cancelRefresh];
    _personID = personID;
    [self refresh];
}

- (NSString *)getCacheKey
{
    if (_personID != 0 && _personID == [CommonInstance getMainAccount].personId)
    {
        return [NSString stringWithFormat:@"person_%lld", _personID];
    }
    return nil;
}

@end
