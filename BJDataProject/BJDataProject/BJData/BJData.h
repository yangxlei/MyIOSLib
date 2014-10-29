//
//  BJData.h
//  BJDataProject
//
//  Created by 杨磊 on 14-9-5.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJDataDelegate.h"
#import "BJCodeDefine.h"

@class BJUserAccount;
@interface BJData : NSObject
{
    NSMutableArray __strong *_delegates;
    BOOL                    bIsCallbacking;
}

@property (nonatomic, weak) BJUserAccount *mAccount;

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
