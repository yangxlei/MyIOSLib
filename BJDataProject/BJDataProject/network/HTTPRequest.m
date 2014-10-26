//
//  HTTPRequest.m
//  BJDataProject
//
//  Created by Randy on 14/10/25.
//  Copyright (c) 2014年 Randy. All rights reserved.
//

#import "HTTPRequest.h"
#import <AFHTTPClient.h>
#import "HTTPResult.h"

static NSUInteger REQUSET_TASK_ID = 0;
static int REQUSET_TIME_OUT = 10;

@interface HTTPRequest ()
@property (strong, nonatomic)AFHTTPRequestOperation *requestOper;
@property (copy, nonatomic)HTTPRequestResult resultCallback;
@property (assign, nonatomic)BOOL isCancel;
@end

@implementation HTTPRequest

- (instancetype)initWithUrl:(NSString *)url
                       type:(REQUSET_ITEM_TYPE)type
                   callback:(HTTPRequestResult)result
{
    self = [super init];
    if (self) {
        _url = url;
        _type = type;
        _resultCallback = result;
        _timeout = REQUSET_TIME_OUT;
        REQUSET_TASK_ID++;
        if (REQUSET_TASK_ID == NSUIntegerMax) {
            REQUSET_TASK_ID = 0;
        }
        _taskID = REQUSET_TASK_ID;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ID:%lu,url:%@,parameter:%@",(unsigned long)self.taskID,self.url,self.parameters];
}

- (void)dealloc
{
    NSLog(@"提示：%@已释放",self);//临时测试此对象是否被正常释放了
    [self.requestOper cancel];
}

- (void)requestHandleSuc:(id) responseObject
{
    NSAssert([NSRunLoop mainRunLoop]==[NSRunLoop currentRunLoop], @"AFNetWork 不是在主线程返回，修改此处");//临时测试，看看是不是在主线程，如果不在，切换到主线程
    self.isFinish = YES;
    if (self.resultCallback && !self.isCancel) {
        HTTPResult *result = [[HTTPResult alloc] initWithResult:self response:responseObject error:Nil];
        self.resultCallback(self, result);
    }
}

- (void)requestHandleError:(NSError *)error
{
    NSAssert([NSRunLoop mainRunLoop]==[NSRunLoop currentRunLoop], @"AFNetWork 不是在主线程返回，修改此处");
    self.isFinish = YES;
    if (self.resultCallback && !self.isCancel) {
        HTTPResult *result = [[HTTPResult alloc] initWithResult:self response:nil error:error];
        self.resultCallback(self, result);
    }
}

- (void)requestHandleForm:(id<AFMultipartFormData>) formData
{
    if (self.forms) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.forms[@"fileURL"]]
                                   name:self.forms[@"name"]
                               fileName:self.forms[@"fileName"]
                               mimeType:self.forms[@"mimeType"]
                                  error:NULL];
    }
}

- (void)starRequest:(HTTPRequestResult)callback
{
    __weak HTTPRequest *theModel = self;
    
    AFHTTPClient *client = [[AFHTTPClient alloc] init];
    NSMutableURLRequest *request = nil;
    switch (self.type) {
        case REQUSET_ITEM_TYPE_GET:
        {
            request = [client requestWithMethod:@"GET" path:self.url parameters:self.parameters];
            break;
        }
        case REQUSET_ITEM_TYPE_POST_FORM:
        {
            client.parameterEncoding = AFFormURLParameterEncoding;
            if (!self.forms) {
                request = [client requestWithMethod:@"POST" path:self.url parameters:self.parameters];
            }
            else
                request = [client multipartFormRequestWithMethod:@"POST" path:self.url parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [theModel requestHandleForm:formData];
            }];
            break;
        }
        default:
            break;
    }
    
    if (request) {
        self.requestOper = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [theModel requestHandleSuc:JSON];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [theModel requestHandleError:error];
        }];
        [client enqueueHTTPRequestOperation:self.requestOper];
    }
}

- (void)cancelRequest
{
    if (self.requestOper) {
        [self.requestOper cancel];
    }
    self.isCancel = YES;
}

@end
