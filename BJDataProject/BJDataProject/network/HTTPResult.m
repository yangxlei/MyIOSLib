//
//  HTTPResult.m
//  BJDataProject
//
//  Created by Randy on 14/10/25.
//  Copyright (c) 2014年 Randy. All rights reserved.
//

#import "HTTPResult.h"
#import "HTTPRequest.h"

@implementation HTTPResult

- (instancetype)initWithResult:(HTTPRequest *)request
                      response:(id)responseObject
                         error:(NSError *)error
{
    self = [super init];
    if (self) {
        _taskID = request.taskID;
        _url = request.url;
        _parameters = request.parameters;
        _data = responseObject;
        _code = 1;
        if (error) {
            _code = [error code];
            _reason = [error localizedFailureReason];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *result = (NSDictionary *)responseObject;
            _code = [result[@"code"] integerValue];
            _reason = result[@"message"];
        }
    }
    
    return self;
}

@end
