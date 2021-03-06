//
//  HTTPRequest.h
//  BJDataProject
//
//  Created by Randy on 14/10/25.
//  Copyright (c) 2014年 Randy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "APIManager.h"
/************** HTTPRequest *************************/
/**
 内部类，用于描述个请求
 */

typedef enum
{
    REQUEST_ITEM_TYPE_GET				= 0,
    REQUEST_ITEM_TYPE_POST_FORM         = 1,
}
REQUEST_ITEM_TYPE;

@class HTTPRequest;
@class HTTPResult;

@interface HTTPRequest : NSObject
@property (assign, readonly, nonatomic)NSUInteger taskID;
@property (copy, nonatomic)NSString *url;
@property (assign, readonly, nonatomic)REQUEST_ITEM_TYPE type;
@property (strong, nonatomic)NSDictionary *parameters;//post ，get的参数

/*
 forms只包含这四个参数，其它的参数放到 parameters
 
 @param fileURL The URL corresponding to the file whose content will be appended to the form. This parameter must not be `nil`.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param fileName The file name to be used in the `Content-Disposition` header. This parameter must not be `nil`.
 @param mimeType The declared MIME type of the file data. This parameter must not be `nil`.
 */
@property (strong, nonatomic)NSDictionary *forms;//要上传的文件路径

@property (assign, nonatomic)int priority;
@property (assign, nonatomic)int timeout;

/**
 *  标记此次请求结束 ，包括正常结束和被取消
 */
@property (assign, nonatomic)BOOL isFinish;

- (instancetype)initWithUrl:(NSString *)url
                       type:(REQUEST_ITEM_TYPE)type;
- (void)startRequest:(apiRequestFinishCallback)callback;
- (void)startRequest:(apiRequestFinishCallback)callback progress:(apiRequestProgressCallback)proCallback;
- (void)cancelRequest;
@end
