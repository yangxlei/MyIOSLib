//
//  APIManager.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Common.h"
@class HTTPRequest;
@class HTTPResult;

typedef void (^apiRequestFinishCallback)(HTTPRequest *request,HTTPResult *result);
typedef void (^apiRequestProgressCallback)(HTTPRequest *request, long long current, long long total);

/**
    接口管理器，所有接口请求
    包含功能：
    0、接口请求队列
    1、正常的 Get， Post
    2、任务请求的取消
    3、接口 url 的拼装，签名
    4、所有请求返回统一管理, 判断当前请求状态（单点，token失效等）
    5、匿名 token 的获取
 */
@interface APIManager : NSObject

+ (APIManager *)shareInstance;

/**
 *  @param capacity 允许的最大并发数
 *
 *  @return APIManager
 */
- (id)initWithCapacity:(NSUInteger)capacity;

/**
 *  Get 方式请求 API
 *
 *  @param api      需要请求的 API
 *  @param callback 请求完成回调 block
 *
 *  @return 当前请求任务 ID, 在外部可用于主动取消本次请求
 */
- (NSInteger)requestWithGetAPI:(NSString *)api
                      callback:(apiRequestFinishCallback)callback;

/**
 *  Post 方式请求 API
 *
 *  @param api      需要请求的 API
 *  @param postBody post 参数列表 (key, value)
 *  @param callback 请求完成回调 block
 *
 *  @return 当前请求任务 ID, 在外部可用于主动取消本次请求
 */
- (NSInteger)requestWithPostAPI:(NSString *)api
                       postBody:(NSDictionary *)postBody
                       callback:(apiRequestFinishCallback)callback;

/**
 *  下载文件请求
 *
 *  @param api      下载文件地址或者 API
 *  @param progress 下载过程进度回调
 *  @param callback 下载完成回调
 *
 *  @return 当前请求任务 ID, 在外部可用于主动取消本次请求
 */
- (NSInteger)requestDownloadFile:(NSString *)api
                progressCallback:(apiRequestProgressCallback)progress
                  finishCallback:(apiRequestFinishCallback)callback;

/**
 *  上传文件任务请求
 *
 *  @param api      上传文件的地址
 *  @param postBody 上传请求的参数(通常为nil)
 *  @param file     需要上传的文件(具体描述待定，暂时只支持一次上传一个文件)
 *  @param progress 上传过程进度回调
 *  @param callback 上传完成回调
 *
 *  @return 当前请求任务 ID, 在外部可用于主动取消本次请求
 */
- (NSInteger)requestUploadFile:(NSString *)api
                      postBody:(NSDictionary *)postBody
                          file:(NSDictionary *)file
              progressCallback:(apiRequestProgressCallback)progress
                finishCallback:(apiRequestFinishCallback)callback;

/**
 *  取消请求任务
 *
 *  @param taskId 任务 ID
 */
- (void)cancelRequest:(NSInteger)taskId;


- (NSString *)signatureApiWithGet:(NSString *)api account:(BJUserAccount *)account;

@end