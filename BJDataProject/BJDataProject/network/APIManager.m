//
//  APIManager.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "APIManager.h"
#import "BJUserAccount.h"
#include <string.h>
#include "MD5.h"
#include "CTime.h"
#import "JsonUtils.h"

@interface APIItem : NSObject

@property (nonatomic, weak) BJUserAccount *account;
@property (nonatomic, strong) HTTPRequest *httpRequest;
@property (nonatomic, strong) apiRequestFinishCallback finishCallback;
@property (nonatomic, strong) apiRequestProgressCallback progressCallback;
@property (nonatomic, assign) NSInteger taskID;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSDictionary *file;
@property (nonatomic, strong) NSMutableDictionary *postBody;

@property (nonatomic, assign) REQUEST_ITEM_TYPE requestType;
@end

@implementation APIItem
@end

/***************************************/


@interface APIManager()
{
    NSUInteger _capacity;
    NSMutableArray  *_connectionQueue; // 正在请求的任务
    NSMutableArray  *_waitConnectionQueue; // 等待请求的任务
    
    HTTPRequest *handleGetAnonaymousToaknRequest; // 获取匿名 token 任务 id
}

@end

@implementation APIManager

+ (APIManager *)shareInstance
{
    static APIManager *manager = nil;
    if (manager) return manager;
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [[APIManager alloc] initWithCapacity:5];
        }
    }
    
    return manager;
}

- (id)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self)
    {
        NSAssert(capacity > 0, @"capacity 必须大于0");
        _capacity = capacity;
        _connectionQueue = [[NSMutableArray alloc] initWithCapacity:_capacity];
        _waitConnectionQueue = [[NSMutableArray alloc] initWithCapacity:_capacity * 2];
    }
    return self;
}

- (NSInteger)requestAPIWithGet:(NSString *)api
                      callback:(apiRequestFinishCallback)callback
{
    return [self createAPIItemWithGet:api
                     progressCallback:nil
                       finishCallback:callback];
}

- (NSInteger)requestAPIWithPost:(NSString *)api
                       postBody:(NSDictionary *)postBody
                       callback:(apiRequestFinishCallback)callback
{
    return [self createAPIItemWithPost:api
                              postBody:postBody
                                  file:nil
                      progressCallback:nil finishCallback:callback];
}

- (NSInteger)requestDownloadFile:(NSString *)api
                progressCallback:(apiRequestProgressCallback)progress
                  finishCallback:(apiRequestFinishCallback)callback
{
    return [self createAPIItemWithGet:api
                     progressCallback:progress
                       finishCallback:callback];
}

- (NSInteger)requestUploadFile:(NSString *)api
                      postBody:(NSDictionary *)postBody
                          file:(NSDictionary *)file
              progressCallback:(apiRequestProgressCallback)progress
                finishCallback:(apiRequestFinishCallback)callback
{
    return [self createAPIItemWithPost:api
                              postBody:postBody
                                  file:file
                      progressCallback:progress
                        finishCallback:callback];
}

- (void)cancelRequest:(NSInteger)taskId
{
    __weak typeof(self) tempSelf = self;
    [_waitConnectionQueue enumerateObjectsUsingBlock:^(APIItem *apiItem, NSUInteger idx, BOOL *stop) {
       if (apiItem.taskID == taskId)
       {
           [apiItem.httpRequest cancelRequest];
           [tempSelf cleanApiItem:apiItem];
           [_waitConnectionQueue removeObject:apiItem];
           [tempSelf updateAPIItemInQueue];
          *stop = YES;
       }
    }];
    
    [_connectionQueue enumerateObjectsUsingBlock:^(APIItem *apiItem, NSUInteger idx, BOOL *stop) {
        if (apiItem.taskID == taskId)
        {
            [apiItem.httpRequest cancelRequest];
            [tempSelf cleanApiItem:apiItem];
            [_connectionQueue removeObject:apiItem];
            [tempSelf updateAPIItemInQueue];
            *stop = YES;
        }
    }];
}

/**
 *  Get 请求模式下，创建 APIItem
 *
 *  @param api
 *  @param progressCallback
 *  @param finishCallback
 *
 *  @return
 */
- (NSInteger)createAPIItemWithGet:(NSString *)api
                 progressCallback:(apiRequestProgressCallback)progressCallback
                   finishCallback:(apiRequestFinishCallback)finishCallback
{
    APIItem *item = [[APIItem alloc] init];
    
    BJUserAccount *account = [[Common shareInstance] getMainAccount];
    if (account.authToken != nil)
    {
        item.account = account;
    }
    else
    {
        item.account = [[Common shareInstance] getAnonymousAccount];
    }
    item.progressCallback = progressCallback;
    item.finishCallback = finishCallback;
    //item.url = [self signatureApiWithGet:api account:item.account];
    item.url = api;
    item.requestType = REQUEST_ITEM_TYPE_GET;
    item.httpRequest = [[HTTPRequest alloc] initWithUrl:nil type:REQUEST_ITEM_TYPE_GET];
    
    item.taskID = item.httpRequest.taskID;
    
    //add item into waitQueue
    [_waitConnectionQueue addObject:item];
    [self updateAPIItemInQueue];
    
    return item.taskID;
}

- (NSInteger)createAPIItemWithPost:(NSString *)api
                          postBody:(NSDictionary *)postBody
                              file:(NSDictionary *)file
                  progressCallback:(apiRequestProgressCallback)progressCallback
                    finishCallback:(apiRequestFinishCallback)finishCallback
{
    APIItem *item = [[APIItem alloc] init];
    BJUserAccount *account = [[Common shareInstance] getMainAccount];
    if(account.authToken != nil)
    {
        item.account = account;
    }
    else
    {
        item.account = [[Common shareInstance] getAnonymousAccount];
    }
    
    item.progressCallback = progressCallback;
    item.finishCallback = finishCallback;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:postBody];
    item.file = file;
    item.postBody = dic;
    item.url = api;
    item.requestType = REQUEST_ITEM_TYPE_POST_FORM;
    item.httpRequest = [[HTTPRequest alloc] initWithUrl:nil type:REQUEST_ITEM_TYPE_POST_FORM];
    item.taskID = item.httpRequest.taskID;
    
    [_waitConnectionQueue addObject:item];
    [self updateAPIItemInQueue];
    
    return item.taskID;
}

/**
 *  更新两个队列中 APIItem 的执行
 */
- (void)updateAPIItemInQueue
{
    @synchronized(self)
    {
        __weak typeof(self) tempSelf = self;
        [_waitConnectionQueue enumerateObjectsUsingBlock:^(APIItem *apiItem, NSUInteger idx, BOOL *stop) {
            if (apiItem.account == [[Common shareInstance] getAnonymousAccount])
            { // 检验匿名token是否已经获取
                if (apiItem.account.authToken == nil)
                {
                    //create anony token
                    [tempSelf createAnonaymousAccount];
                    *stop = YES;
                    return ;
                }
                else
                { // 使用匿名账户的 token
                    [tempSelf handleAPIItem:apiItem];
                }
                
            }
            else
            {
                [tempSelf handleAPIItem:apiItem];
            }
            
        }];
    }
}

/**
 *  匿名账户没有值，首先创建匿名账户。创建成功的话才去走正常的请求
 */
- (void)createAnonaymousAccount
{
    if (handleGetAnonaymousToaknRequest != nil && ! [handleGetAnonaymousToaknRequest isFinish])
        return;
    
    NSString *anonaymouseAPI = [NSString stringWithFormat:@"%@%@", [[Common shareInstance] getAnonymousAccount].hostUrl, API_GET_ANONYMOUS_TOKEN];
    handleGetAnonaymousToaknRequest = [[HTTPRequest alloc] initWithUrl:anonaymouseAPI type:REQUEST_ITEM_TYPE_POST_FORM];
//    _handleRefreshAnonymousTokenTaskId = request.taskID;
    
    
    __weak typeof(self) tempSelf = self;
    [handleGetAnonaymousToaknRequest startRequest:^(HTTPRequest *request, HTTPResult *result) {
        if (result.code == ERROR_SUCCESSFULL)
        {
            NSDictionary *_result = [result.data dictionaryValueForKey:@"result"];
            [[[Common shareInstance] getAnonymousAccount] loginWithPerson:[_result longLongValueForKey:@"id" defalutValue:0] token:[_result stringValueForKey:@"auth_token" defaultValue:nil]];
            [tempSelf updateAPIItemInQueue];
        }
        else
        {
            // 匿名用户创建失败，取消当前账户下所有的网络请求
            [tempSelf cancelRequestWithAccount:[[Common shareInstance] getAnonymousAccount]];
        }
        
        handleGetAnonaymousToaknRequest = nil;
    }];
}

/**
 *  正常处理所有的请求： 对 item url 进行签名---》加入到正在请求队列----》开始请求--->处理回调
 */
- (void)handleAPIItem:(APIItem *)apiItem
{
    @synchronized(self)
    {
        if ([_connectionQueue count] >= _capacity)
            return;
        
        [_connectionQueue addObject:apiItem];
        [_waitConnectionQueue removeObject:apiItem];
        
        if (apiItem.requestType == REQUEST_ITEM_TYPE_GET)
        {
            NSString *url = [self signatureApiWithGet:apiItem.url account:apiItem.account];
            //TODO add Global params
            
            apiItem.url = url;
            apiItem.httpRequest.url = url;
        }
        else
        {
            NSString *url = [self signatureApiWithPost:apiItem.url postBody:apiItem.postBody account:apiItem.account];
            //TODO insert Global Params
            
            apiItem.url = url;
            apiItem.httpRequest.url = url;
            apiItem.httpRequest.parameters = apiItem.postBody;
            apiItem.httpRequest.forms = apiItem.file;
        }
        
        __weak typeof(self) tempSelf = self;
        [apiItem.httpRequest startRequest:^(HTTPRequest *request, HTTPResult *result) {
            
            [tempSelf handleAPIItemFinishCallback:request.taskID httpResult:result];
            [tempSelf cleanApiItem:apiItem];
            [_connectionQueue removeObject:apiItem];
            [tempSelf updateAPIItemInQueue];
            
        } progress:^(HTTPRequest *request, long long current, long long total) {
            
            [tempSelf handleAPIItemProgressCallback:request.taskID current:current total:total];
            
        }];
    }
}

- (void)handleAPIItemFinishCallback:(NSInteger)taskID httpResult:(HTTPResult *)result
{
    @synchronized(self)
    {
        __weak typeof(self) tempSelf = self;
        [_connectionQueue enumerateObjectsUsingBlock:^(APIItem *apiItem, NSUInteger idx, BOOL *stop) {
           if (apiItem.taskID == taskID)
           {
               BJUserAccount *account = apiItem.account;
               int code = (int)result.code;
               if (code == ERROR_ANOTHER_LOGIN)
               {
                   if ([account isLogin])
                   {
                       [account logoutWithOperation:ERROR_ANOTHER_LOGIN];
                       [tempSelf cancelRequestWithAccount:account];
                   }
               }
               else if (code == ERROR_OAUTH_TOKEN_BROKEN)
               { // token 失效，请重新登录
                   // account invalid access token
                   [account logoutWithOperation:ERROR_OAUTH_TOKEN_BROKEN];
                   [tempSelf cancelRequestWithAccount:account];
               }
               else if (code == ERROR_NEED_REFRESH_OAUTH_TOKEN)
               {
                   //token 过期，可以自动刷新。服务器暂不支持，后期实现
               }
               else
               {
                   if (apiItem.finishCallback)
                   {
                       apiItem.finishCallback(apiItem.httpRequest, result);
                   }
               }
               *stop = YES;
           }
        }];
    }
}

- (void)handleAPIItemProgressCallback:(NSInteger)taskID current:(long long)current total:(long long)total
{
    @synchronized(self)
    {
        [_connectionQueue enumerateObjectsUsingBlock:^(APIItem *apiItem, NSUInteger idx, BOOL *stop) {
            if (apiItem.taskID == taskID) {
                if (apiItem.progressCallback)
                {
                    apiItem.progressCallback(apiItem.httpRequest, current, total);
                }
                *stop = YES;
            }
        }];
    }
}

/**
 *  将对应 account 下的所有请求都取消
 *
 *  @param account
 */
- (void)cancelRequestWithAccount:(BJUserAccount *)account
{
    __weak typeof(self) tempSelf = self;
    [_waitConnectionQueue enumerateObjectsUsingBlock:^(APIItem *apiItem, NSUInteger idx, BOOL *stop) {
        if (apiItem.account == account)
        {
            HTTPResult *result = [[HTTPResult alloc] initWithRequest:apiItem.httpRequest code:ERROR_CANCEL];
            [apiItem.httpRequest cancelRequest];
            apiItem.finishCallback(apiItem.httpRequest, result);
            [tempSelf cleanApiItem:apiItem];
            [_waitConnectionQueue removeObject:apiItem];
        }
    }];
    
    [_connectionQueue enumerateObjectsUsingBlock:^(APIItem *apiItem, NSUInteger idx, BOOL *stop) {
        if (apiItem.account == account)
        {
            HTTPResult *result = [[HTTPResult alloc] initWithRequest:apiItem.httpRequest code:ERROR_CANCEL];
            [apiItem.httpRequest cancelRequest];
            apiItem.finishCallback(apiItem.httpRequest, result);
            [tempSelf cleanApiItem:apiItem];
            [_connectionQueue removeObject:apiItem];
        }
    }];
}

- (void)cleanApiItem:(APIItem *)apiItem
{
    apiItem.account = nil;
    apiItem.url = nil;
    apiItem.postBody = nil;
    apiItem.file = nil;
    apiItem.httpRequest = nil;
    apiItem.progressCallback = nil;
    apiItem.finishCallback = nil;
    apiItem.taskID = 0;
}

/**
 *  对 Get 请求的链接进行签名
 *
 *  @param api
 *  @param account 当前请求属于哪个 account 下
 *
 *  @return 签名处理后的完整链接
 */
- (NSString *)signatureApiWithGet:(NSString *)api account:(BJUserAccount *)account
{
    if ([api hasPrefix:@"http://"])
    { // 如果传进来的是 http 开头的 url. 默认为外部链接，不做签名直接请求
        return api;
    }
    NSString *fullApi = [NSString stringWithFormat:@"%@%@", account.hostUrl, api];
    
    char resultApi[2048] = {0};
    strcat(resultApi, [fullApi UTF8String]);
    
    if (strstr(resultApi, "?"))
    {
        strcat(resultApi, "auth_token=");
    }
    else
    {
        strcat(resultApi, "?&auth_token=");
    }
    strcat(resultApi, [account.authToken UTF8String]);
    
    char timestamp[16] = {0};
    sprintf(timestamp, "%lld", bj_get_time());
    strcat(resultApi, "&timestamp=");
    strcat(resultApi, timestamp);
    
    NSString *sign = [self computeSignature:fullApi authToken:account.authToken timestamp:timestamp appkey:account.appKey];
    strcat(resultApi, "&signature=");
    strcat(resultApi, [sign UTF8String]);
    
    strcat(resultApi, "&version=");
    strcat(resultApi, [CommonInstance.app_version UTF8String]);
    
    strcat(resultApi, "&api=");
    strcat(resultApi, [CommonInstance.app_build_version UTF8String]);
    
    strcat(resultApi, "&platform=");
    strcat(resultApi, [CommonInstance.system_name UTF8String]);
    
    strcat(resultApi, "&os=");
    strcat(resultApi, [CommonInstance.system_version UTF8String]);
    
    strcat(resultApi, "&uuid=");
    strcat(resultApi, [CommonInstance.device_uuid UTF8String]);
    
    strcat(resultApi, "&channel=");
    strcat(resultApi, [CommonInstance.app_channel UTF8String]);
    
    return [NSString stringWithUTF8String:resultApi];
}

/**
 *  对 Post 请求进行 url 封装，及签名
 *
 *  @param api
 *  @param postBody
 *  @param account
 *
 *  @return
 */
- (NSString *)signatureApiWithPost:(NSString *)api
                          postBody:(NSMutableDictionary *)postBody
                           account:(BJUserAccount *)account
{

    if ([api hasPrefix:@"http://"])
    {// 如果传进来的是 http 开头的 url. 默认为外部链接，不做签名直接请求
        return api;
    }
    
    NSString *fullApi = [NSString stringWithFormat:@"%@%@", account.hostUrl, api];
    
    char _fullApi[1024] = {0};
    strcat(_fullApi, [fullApi UTF8String]);
    
    char *param_index = strstr(_fullApi, "?&");
    char *_param_index = NULL;
    if (param_index == NULL)
    {
        param_index = strstr(_fullApi, "?");
        if (param_index != NULL)
        {
            _param_index = param_index + 1;
        }
    }
    else
    {
        _param_index = param_index + 2;
    }
    
    char *api_end = _fullApi;
    api_end += strlen(_fullApi);
    
    char _api[64] = {0};
    
    if (param_index != NULL)
    {//包含 ?, 表示传进来的 api 中包含了参数，把参数截取出来
        strncpy(_api, _fullApi, param_index - _fullApi);
        while (_param_index != NULL && _param_index < api_end)
        {
            char *param_key_index = strstr(_param_index + 1, "=");
            char key[32] = {0};
            strncpy(key, _param_index, param_key_index - _param_index);
            
            _param_index = param_key_index + 1;
            char *param_value_index = strstr(param_key_index + 1, "&");
            if (param_value_index == NULL)
            {
                param_value_index = api_end;
            }
            char value[64]={0};
            strncpy(value, _param_index, param_value_index - _param_index);
            
            //将 api 中的参数放入 postBody 中
            [postBody setObject:[NSString stringWithUTF8String:value] forKey:[NSString stringWithUTF8String:key]];
            
            _param_index = param_value_index + 1;
        }
    }
    else
    { // 传进来的 api 中不带参数, 直接使用原有的 api
        strcpy(_api, _fullApi);
    }
    
    if (account.authToken != nil)
    {
        [postBody setObject:account.authToken forKey:@"auth_token"];
    }
    
    char timestamp[32] = {0};
    sprintf(timestamp, "%lld", bj_get_time());
    [postBody setObject:[NSString stringWithUTF8String:timestamp] forKey:@"timestamp"];
    
    NSString *signature = [self computeSignature:fullApi authToken:account.authToken timestamp:timestamp appkey:account.appKey];
    [postBody setObject:signature forKey:@"signature"];
    
    [postBody setObject:CommonInstance.app_version forKey:@"version"];
    [postBody setObject:CommonInstance.app_build_version forKey:@"api"];
    [postBody setObject:CommonInstance.system_name forKey:@"platform"];
    [postBody setObject:CommonInstance.system_version forKey:@"os"];
    [postBody setObject:CommonInstance.device_uuid forKey:@"uuid"];
    [postBody setObject:CommonInstance.app_channel forKey:@"channel"];
    
    return [NSString stringWithUTF8String:_api];
}

/**
 *  根据参数计算 url 的签名
 *
 *  @param fullApi   除签名外完整的 url api
 *  @param authToken 服务器分配的 auth_token
 *  @param timestamp 请求的时间戳
 *  @param appkey    定义好的 appkey
 *
 *  @return 生成的签名
 */
- (NSString *)computeSignature:(NSString *)fullApi
                     authToken:(NSString *)authToken
                     timestamp:(char *)timestamp
                        appkey:(NSString *)appkey
{
    
    char apiGroup[128] = {0};
    char apiName[64] = {0};
    const char *_fullapi = [fullApi UTF8String];
    
    char *protocal_index = strstr(_fullapi, "://");
    protocal_index += 3;
    
    char *path_index = strstr(protocal_index, "/");
    if (path_index == NULL)
        return @"";
    
    char *path_end = strstr(_fullapi, "?");
    if (path_end == NULL)
    {
        path_end = _fullapi;
        path_end += strlen(_fullapi);
    }
    
    while (path_index < path_end) {
        char *next_index = strstr(path_index + 1, "/");
        if (next_index == NULL)
        {
            break;
        }
        
        strncat(apiGroup, path_index + 1, next_index - path_index - 1);
        path_index = next_index;
    }
    
    strncat(apiName, path_index + 1, path_end - path_index - 1);
    
    char temp[256] = {0};
    // authtoken apigroup apiname timestamp appkey
    sprintf(temp, "%s%s%s%s%s", [authToken UTF8String], apiGroup, apiName, timestamp, [appkey UTF8String]);
    
    char sign[64] = {0};
    md5_encode_str(sign, temp);

    return [NSString stringWithUTF8String:sign];
}

@end
