//
//  APITask.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "APITask.h"
#import "APIManager.h"

@interface APITask()
{
    NSString *_api;
    NSDictionary *_postBody;
    REQUEST_ITEM_TYPE _requestType;
}

@end

@implementation APITask

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSAssert(0, @"请调用 initWithxxx 方法");
    }
    return self;
}

- (instancetype)initWithAPI:(NSString *)api
{
    self = [super init];
    if (self)
    {
        _requestType = REQUEST_ITEM_TYPE_GET;
        _api = api;
    }
    return self;
}

- (instancetype)initWithAPI:(NSString *)api postBody:(NSDictionary *)postBody
{
    self = [super init];
    if (self)
    {
        _requestType = REQUEST_ITEM_TYPE_POST_FORM;
        _api = api;
        _postBody = postBody;
    }
    return self;
}

- (int)DoTask
{
    __weak typeof(self) tempSelf = self;
    if (_requestType == REQUEST_ITEM_TYPE_GET)
    {
        self.taskId = [APIManagerInstance requestAPIWithGet:_api callback:^(HTTPRequest *request, HTTPResult *result) {
            [tempSelf TaskCompleted:(int)result.code result:result];
        }];
    }
    else
    {
        self.taskId = [APIManagerInstance requestAPIWithPost:_api postBody:_postBody callback:^(HTTPRequest *request, HTTPResult *result) {
            [tempSelf TaskCompleted:(int)result.code result:result];
        }];
    }
    return (int)self.taskId;
}

- (void)CancelTask
{
    [APIManagerInstance cancelRequest:self.taskId];
}

@end
