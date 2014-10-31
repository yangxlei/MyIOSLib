//
//  HTTPResult.m
//  BJDataProject
//
//  Created by Randy on 14/10/25.
//  Copyright (c) 2014年 Randy. All rights reserved.
//

#import "HTTPResult.h"
#import "HTTPRequest.h"
#import "JsonUtils.h"
#import "BJCodeDefine.h"

@implementation HTTPResult

- (instancetype)initWithRequest:(HTTPRequest *)request
                      response:(id)responseObject
                         error:(NSError *)error
{
    self = [super init];
    if (self) {
        _taskID = request.taskID;
        _url = request.url;
        _parameters = request.parameters;
        _data = [JsonUtils convertJsonObject:responseObject];
        _code = 1;

        if (error)
        {
            _code = [error code];
            _reason = [error localizedFailureReason];
        }
        else if ([_data isKindOfClass:[NSDictionary class]])
        {
//            NSDictionary *result = (NSDictionary *)responseObject;
            _code = [_data intValueForkey:@"code" defaultValue:BJ_ERROR_UNKNOW];//[result[@"code"] integerValue];
            _reason = [_data getError];
        }
       
    }
    
    return self;
}

- (instancetype)initWithRequest:(HTTPRequest *)request code:(BJDATA_ERROR_CODE)code
{
    self = [super init];
    if (self)
    {
        _taskID = request.taskID;
        _url = request.url;
        _parameters = request.parameters;
        _code = code;
        _data = [JsonUtils newJsonObject:NO];
        [_data setIntValue:code forKey:@"code"];
    }
    return self;
}

@end
