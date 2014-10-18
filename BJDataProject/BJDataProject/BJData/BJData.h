//
//  BJData.h
//  BJDataProject
//
//  Created by 杨磊 on 14-9-5.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJDataDelegate.h"

enum _error_code
{
    ERROR_NETWORK= -1,
    ERROR_UNKNOW = -100,
    
    ERROR_SUCCESSFULL = 1,
    ERROR_CANCEL = 2,
    ERROR_OAUTH_LOGIN = 100,
    
    ERROR_BLACK = 99,
    ERROR_OAUTH_TOKEN_BROKEN = 98,
    ERROR_NEED_REFRESH_OAUTH_TOKEN = 100115,
    ERROR_VALIDATE_CODE_EMPTY = 900002,
    ERROR_VALIDATE_CODE_WRONG = 900003,
    ERROR_LOCATION_DISABLE = 900004,
    ERROR_LOCATION_UPDATE_ERROR_SYSTEM = 900005,
    
}BJDATA_ERROR_CODE;

enum _status_code
{
    STATUS_NO_CONNECT_AND_NO_DATA = 0,
    STATUS_NETWORK_ERROR_AND_NO_DATA = 1,
    STATUS_EMPTY = 2,
    STATUS_HAVE_DATA = 3,
    STATUS_DATA_DELETED = 4,
    STATUS_NO_PERMISSION = 5,
}BJDATA_STATUS_CODE;

enum _ope_code
{
    OPERATION_REFRESH = 1,
    OPERATION_GET_MORE = 2,
}BJDATA_OPERATION_CODE;

@class BJUserAccount;
@interface BJData : NSObject
{
    NSMutableArray __strong *_delegates;
    BOOL                    bIsCallbacking;
}

@property (nonatomic, weak) BJUserAccount *account;

/**
 保存数据到缓存
 */
- (void)saveCache;

/**
 从缓存中加载数据
 */
- (void)loadCache;

/**
 数据保存的文件名
 */
- (NSString *)getCacheKey;

/**
 返回当前数据类型，可根据特殊情况定制，默认为当前类名
 */
- (NSString *)getType;

/**
 注册数据代理, 自动过滤重复的 delegate 
 */
- (void)addDelegate:(id<BJDataDelegate>)_delegate;

/**
 移除数据代理
 */
- (void)removeDelegate:(id<BJDataDelegate>)_delegate;

/**
 判断是否包含目标代理
 */
- (BOOL)containsDelegate:(id<BJDataDelegate>)_delegate;

/**
 是否正在执行某个操作
 */
//- (BOOL)isOperation:(int)ope;

/**
    执行代理回调
 @param error 结果状态
 @param ope   当前操作
 @param error_message  错误信息
 */
- (void)invokeDelegateWithError:(int)error
                   ope:(int)ope
         error_message:(NSString *)error_message
                params:(id)params;

@end
