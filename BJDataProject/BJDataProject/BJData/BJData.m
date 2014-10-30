//
//  BJData.m
//  BJDataProject
//
//  Created by 杨磊 on 14-9-5.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJData.h"
#import "Common.h"
#import "BJDataFactory.h"

/** delegate 已被删除标记 */
#define DELEGATE_MASK_REMOVE 1

/**
 @discussion 对 BJDataDelegate 的封装，用于存储代理对象。
 @discussion 本类为内部类，不对外开放
 @discussion PS:本类对 delegate 并不持有，所以在 data 使用完成之后注意 remove delegate.
 @param delegate_mask 用于标记当前 delegate 的状态。
 */
@interface _BJDataDelegate : NSObject

@property (nonatomic, weak) id<BJDataDelegate> delegate;
@property (nonatomic, assign) int                delegate_mask;

- (id)initWithBJDataDelegate:(id<BJDataDelegate>) _del;

@end

@implementation _BJDataDelegate

- (id)initWithBJDataDelegate:(id<BJDataDelegate>)_del
{
    self = [self init];
    if (self)
    {
        _delegate = _del;
        _delegate_mask = 0;
    }
    return self;
}

@end

/****************************/

@implementation BJData

- (id)init
{
    self = [super init];
    if (self)
    {
        _delegates = [[NSMutableArray alloc] initWithCapacity:3];
        bIsCallbacking = NO;
        [[BJDataFactory shareInstance] addBJDataIntoLink:self];
    }
    return self;
}

- (void)dealloc
{
    _delegates = nil;
    [[BJDataFactory shareInstance] removeBJDataFromLink:self];
}

- (void)saveCache
{
}

- (void)loadCache
{
}

- (BOOL)messageHandle:(NSString *)message params:(id)params
{
//    if ([CommonInstance.mainAccount isLogin] && _mAccount == CommonInstance.anonymousAccount)
//    {
//        _mAccount = CommonInstance.mainAccount;
//    }
    return NO;
}

- (BJUserAccount *)mAccount
{
    if (_mAccount != nil)
    {
        return _mAccount;
    }
    if (CommonInstance.mainAccount)
    {
        _mAccount = CommonInstance.mainAccount;
    }
    else
    {
        _mAccount = CommonInstance.anonymousAccount;
    }
    return _mAccount;
}

- (NSString *)getType
{
    return NSStringFromClass([self class]);
}

- (NSString *)getCacheKey
{
    return nil;
}

- (void)addDelegate:(id<BJDataDelegate>)_delegate
{
    BOOL find = NO;
    for (NSUInteger i = 0; i < [_delegates count]; ++ i)
    {
        _BJDataDelegate *del = [_delegates objectAtIndex:i];
        if ([del delegate] == _delegate)
        {
            // 如果已被删除，使之可以继续使用
            if ((del.delegate_mask & DELEGATE_MASK_REMOVE) == DELEGATE_MASK_REMOVE)
            {
                del.delegate_mask |= ~DELEGATE_MASK_REMOVE;
            }
            find = YES;
            break;
        }
    }
    
    if (find)
    {
        return;
    }
    
    _BJDataDelegate *del = [[_BJDataDelegate alloc] initWithBJDataDelegate:_delegate];
    [_delegates addObject:del];
}

/**
 执行删除时，先只执行逻辑删除
 */
- (void)removeDelegate:(id<BJDataDelegate>)_delegate
{
    BOOL find = NO;
    for (NSUInteger i = 0; i < [_delegates count]; ++ i)
    {
        _BJDataDelegate *del = [_delegates objectAtIndex:i];
        if ([del delegate] == _delegate)
        {
            del.delegate_mask |= DELEGATE_MASK_REMOVE;
            find = YES;
            break;
        }
    }
    
    // 在当前没有操作的情况下，执行真正的删除操作
    if (bIsCallbacking == NO && find)
    {
        [self cleanDelegates];
    }
}

- (void)invokeDelegateWithError:(int)error
                            ope:(int)ope
                  error_message:(NSString *)error_message
                         params:(id)params
{
    bIsCallbacking = YES;
   
    for (NSUInteger i = 0; i < [_delegates count]; ++ i) {
        _BJDataDelegate *del = [_delegates objectAtIndex:i];
        if ((del.delegate_mask & DELEGATE_MASK_REMOVE) != DELEGATE_MASK_REMOVE)
        {
            [[del delegate] dataEvent:self error:error ope:ope error_message:error_message params:params];
        }
    }
    
    bIsCallbacking = NO;
    [self cleanDelegates];
}

- (BOOL)containsDelegate:(id<BJDataDelegate>)_delegate
{
    BOOL find = NO;
    
    for (NSUInteger i = 0; i < [_delegates count]; ++ i) {
        _BJDataDelegate *del = [_delegates objectAtIndex:i];
        if (del.delegate == _delegate && (del.delegate_mask & DELEGATE_MASK_REMOVE) != DELEGATE_MASK_REMOVE)
        {
            find = YES;
            break;
        }
    }
    
    return find;
}

/**
 清除掉已被删除的 delegate
 */
- (void)cleanDelegates
{
    for (NSUInteger i = 0; i < [_delegates count]; ++ i)
    {
        _BJDataDelegate *del = [_delegates objectAtIndex:i];
        if ((del.delegate_mask & DELEGATE_MASK_REMOVE) == DELEGATE_MASK_REMOVE)
        {
            [_delegates removeObjectAtIndex:i];
            i -- ;
        }
    }
}

@end
