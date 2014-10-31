//
//  BJListData.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJListData.h"
#import "JsonUtils.h"
#import "BJFileManager.h"

@interface BJListData()
{
    TaskQueue *tasks[8];
    listDataOperationCallback operationCallbacks[8];
    BOOL _hasMore;
}

// 服务器 list 返回参数
@property (nonatomic, copy) NSString *mNextCursor;
@property (nonatomic, copy) NSString *mPreCursor;
@property (nonatomic, assign) int mTotalNum;
@end

@implementation BJListData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _status = BJ_STATUS_NO_CONNECT_AND_NO_DATA;
    }
    return self;
}

- (void)dealloc
{
    [self cancelOperation:BJ_OPERATION_ALL];
}

- (NSMutableArray *)list
{
    if (_list == nil)
    {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

- (void)refresh
{
    if (tasks[BJ_OPERATION_REFRESH] == nil)
    {
        tasks[BJ_OPERATION_REFRESH] = [[TaskQueue alloc] init];
        [self doRefreshOperation:tasks[BJ_OPERATION_REFRESH]];
        tasks[BJ_OPERATION_REFRESH].delegate = self;
        [tasks[BJ_OPERATION_REFRESH] start:nil];
    }
}

- (void)refresh:(listDataOperationCallback)operationCallback
{
    [self refresh];
    operationCallbacks[BJ_OPERATION_REFRESH] = operationCallback;
}

- (void)doRefreshOperation:(TaskQueue *)taskQueue
{
}

- (void)getMore
{
    if (tasks[BJ_OPERATION_REFRESH] == nil && [self hasMore] && tasks[BJ_OPERATION_GET_MORE] == nil)
    {
        tasks[BJ_OPERATION_GET_MORE] = [[TaskQueue alloc] init];
        [self doGetMoreOperation:tasks[BJ_OPERATION_GET_MORE]];
        tasks[BJ_OPERATION_GET_MORE].delegate = self;
        [tasks[BJ_OPERATION_GET_MORE] start:nil];
    }
}

- (void)getMore:(listDataOperationCallback)operationCallback
{
    [self getMore];
    operationCallbacks[BJ_OPERATION_GET_MORE] = operationCallback;
}

- (void)doGetMoreOperation:(TaskQueue *)taskQueue
{
}

- (BOOL)hasMore
{
    return _hasMore;
}

- (BOOL)addItem:(id)item at:(NSInteger)index
{
    if ([self isOperation:BJ_OPERATION_REFRESH])
    { //如果正在刷新，取消刷新操作
        [self cancelOperation:BJ_OPERATION_REFRESH];
    }
    
    if ([self isOperation:BJ_OPERATION_REMOVE_ITEM])
    {
    
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_ADD_ITEM error_message:@"正在处理删除操作，请稍后再试" params:item];
        return NO;
    }
    
    if ([self isOperation:BJ_OPERATION_SAVE_ITEM])
    {
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_ADD_ITEM error_message:@"正在处理编辑保存操作，请稍后再试" params:item];
        return NO;
    }
    
    if ([self isOperation:BJ_OPERATION_ADD_ITEM])
    {
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_ADD_ITEM error_message:@"正在处理添加操作，请稍后再试" params:item];
        return NO;
    }
    
    if (tasks[BJ_OPERATION_ADD_ITEM] == nil)
    {
        [_list insertObject:item atIndex:index];
        _status = BJ_STATUS_HAVE_DATA;
        [self invokeDelegateWithError:BJ_ERROR_SUCCESSFULL ope:BJ_OPERATION_DATA_CHANGED error_message:@"" params:item];
        
        tasks[BJ_OPERATION_ADD_ITEM] = [[TaskQueue alloc] init];
        [self doAddItemOperation:tasks[BJ_OPERATION_ADD_ITEM] at:index];
        tasks[BJ_OPERATION_ADD_ITEM].delegate = self;
        [tasks[BJ_OPERATION_ADD_ITEM] start:[NSNumber numberWithInteger:index]];
        
        return YES;
    }
    return NO;
}

- (BOOL)addItem:(id)item at:(NSInteger)index block:(listDataOperationCallback)operationCallback
{
    operationCallbacks[BJ_OPERATION_ADD_ITEM] = operationCallback;
    return [self addItem:item at:index];
}

- (void)doAddItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index
{
}

- (BOOL)removeItem:(NSInteger)index
{
    if ([self isOperation:BJ_OPERATION_REFRESH])
    {
        [self cancelOperation:BJ_OPERATION_REFRESH];
    }
    
    if ([self isOperation:BJ_OPERATION_REMOVE_ITEM])
    {
        
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_REMOVE_ITEM error_message:@"正在处理删除操作，请稍后再试" params:[NSNumber numberWithInteger:index]];
        return NO;
    }
    
    if ([self isOperation:BJ_OPERATION_SAVE_ITEM])
    {
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_REMOVE_ITEM error_message:@"正在处理编辑保存操作，请稍后再试" params:[NSNumber numberWithInteger:index]];
        
        return NO;
    }
    
    if ([self isOperation:BJ_OPERATION_ADD_ITEM])
    {
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_REMOVE_ITEM error_message:@"正在处理添加操作，请稍后再试" params:[NSNumber numberWithInteger:index]];
        
        return NO;
    }
    
    if (tasks[BJ_OPERATION_REMOVE_ITEM] == nil)
    {
        tasks[BJ_OPERATION_REMOVE_ITEM] = [[TaskQueue alloc] init];
        [self doRemoveItemOperation:tasks[BJ_OPERATION_REMOVE_ITEM] at:index];
        tasks[BJ_OPERATION_REMOVE_ITEM].delegate = self;
        [tasks[BJ_OPERATION_REMOVE_ITEM] start:[NSNumber numberWithInteger:index]];
        return YES;
    }
    return NO;
}

- (BOOL)removeItem:(NSInteger)index block:(listDataOperationCallback)operationCallback
{
    operationCallbacks[BJ_OPERATION_REMOVE_ITEM] = operationCallback;
    return [self removeItem:index];
}

- (void)doRemoveItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index
{
}

- (BOOL)saveItem:(NSInteger)index
{
    if ([self isOperation:BJ_OPERATION_REFRESH])
    {
        [self cancelOperation:BJ_OPERATION_REFRESH];
    }
    
    if ([self isOperation:BJ_OPERATION_REMOVE_ITEM])
    {
        
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_SAVE_ITEM error_message:@"正在处理删除操作，请稍后再试" params:[NSNumber numberWithInteger:index]];
        return NO;
    }
    
    if ([self isOperation:BJ_OPERATION_SAVE_ITEM])
    {
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_SAVE_ITEM error_message:@"正在处理编辑保存操作，请稍后再试" params:[NSNumber numberWithInteger:index]];
        return NO;
    }
    
    if ([self isOperation:BJ_OPERATION_ADD_ITEM])
    {
        [self invokeDelegateWithError:BJ_ERROR_CANCEL ope:BJ_OPERATION_SAVE_ITEM error_message:@"正在处理添加操作，请稍后再试" params:[NSNumber numberWithInteger:index]];
        return NO;
    }
    
    if (tasks[BJ_OPERATION_SAVE_ITEM] == nil)
    {
        [self invokeDelegateWithError:BJ_ERROR_SUCCESSFULL ope:BJ_OPERATION_DATA_CHANGED error_message:nil params:nil];
        tasks[BJ_OPERATION_SAVE_ITEM] = [[TaskQueue alloc] init];
        [self doSaveItemOperation:tasks[BJ_OPERATION_SAVE_ITEM] at:index];
        tasks[BJ_OPERATION_SAVE_ITEM].delegate = self;
        [tasks[BJ_OPERATION_SAVE_ITEM] start:[NSNumber numberWithInteger:index]];
        return YES;
    }
    return NO;
}

- (BOOL)saveItem:(NSInteger)index block:(listDataOperationCallback)operationCallback
{
    operationCallbacks[BJ_OPERATION_SAVE_ITEM] = operationCallback;
    return [self saveItem:index];
}

- (void)doSaveItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index
{
}

- (BOOL)isOperation:(BJDATA_OPERATION_CODE)ope
{
    if (tasks[ope] != nil)
    {
        return YES;
    }
    
    return NO;
}

- (void)cancelOperation:(BJDATA_OPERATION_CODE)ope
{
    if (ope == BJ_OPERATION_ALL)
    {
        for (int i = BJ_OPERATION_REFRESH; i < BJ_OPERATION_ALL; ++ i)
        {
            [tasks[i] cancelQueue];
            tasks[i] = nil;
        }
    }
    else
    {
        [tasks[ope] cancelQueue];
        tasks[ope] = nil;
    }
}

- (void)cleanList
{
    [self cancelOperation:BJ_OPERATION_ALL];
    [self.list removeAllObjects];
    _status = BJ_STATUS_NO_CONNECT_AND_NO_DATA;
    _mNextCursor = nil;
    _mPreCursor = nil;
    _hasMore = NO;
    _mAdditional = nil;
    _mTotalNum = 0;
}

- (void)saveCache
{
    
    NSString *filePath = [BJFileManager getCacheFilePath:[self getCacheKey] withAccount:self.mAccount];
    if (filePath == nil) return;
    
    id json = [JsonUtils newJsonObject:NO];
    if (_list != nil)
    {
        [json setObject:_list forKey:@"list"];
    }
    [json setIntValue:_hasMore forKey:@"has_more"];
    if (_mAdditional != nil)
    {
        [json setObject:_mAdditional forKey:@"additional"];
    }
    
    if (_mNextCursor != nil)
    {
        [json setValue:_mNextCursor forKey:@"next_cursor"];
    }
    if (_mPreCursor != nil)
    {
        [json setValue:_mPreCursor forKey:@"pre_cursor"];
    }
    [json setIntValue:_mTotalNum forKey:@"total_num"];
    
    NSString *code = [JsonUtils jsonToString:json];
    [code writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)loadCache
{
    NSString *filePath = [BJFileManager getCacheFilePath:[self getCacheKey] withAccount:self.mAccount];
    if (filePath != nil)
    {
        NSString *code = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        id json = [code jsonValue];
        if (json != nil)
        {
            _list = (NSMutableArray *)[json arrayValueForKey:@"list"];
            _hasMore = [json intValueForkey:@"has_more" defaultValue:0] == 1;
            _mAdditional = [json dictionaryValueForKey:@"additional"];
            _mNextCursor = [json stringValueForKey:@"next_cursor" defaultValue:@""];
            _mPreCursor = [json stringValueForKey:@"pre_cursor" defaultValue:@""];
            _mTotalNum = [json intValueForkey:@"total_num" defaultValue:0];
            
            if ([_list count] > 0)
            {
                _status = BJ_STATUS_HAVE_DATA;
            }
            else
            {
                _status = BJ_STATUS_EMPTY;
            }
        }
        else
        {
            _status = BJ_STATUS_NO_CONNECT_AND_NO_DATA;
        }
    }
    else
    {
        _status = BJ_STATUS_NO_CONNECT_AND_NO_DATA;
    }
}

#pragma operation callback
- (void)refreshCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    id result = tasks[BJ_OPERATION_REFRESH].result;
    if (error == BJ_ERROR_SUCCESSFULL)
    {
        [self cleanList];
        NSDictionary *_result = [result dictionaryValueForKey:@"result"];
        _list = (NSMutableArray *)[_result arrayValueForKey:@"list"];
        _hasMore = [_result intValueForkey:@"has_more" defaultValue:0] == 1;
        _mTotalNum = (int)[_result intValueForkey:@"total_number" defaultValue:0];
        _mNextCursor = [_result stringValueForKey:@"next_cursor" defaultValue:@""];
        _mPreCursor = [_result stringValueForKey:@"pre_cursor" defaultValue:@""];
        _mAdditional = [_result dictionaryValueForKey:@"additional"];
        [self saveCache];
        
        if ([_list count] > 0)
        {
            _status = BJ_STATUS_HAVE_DATA;
        }
        else
        {
            _status = BJ_STATUS_EMPTY;
        }
    }
    else
    {
        if (_status == BJ_STATUS_NO_CONNECT_AND_NO_DATA)
        {
            _status = BJ_STATUS_NETWORK_ERROR_AND_NO_DATA;
        }
    }
    [self invokeDelegateWithError:error ope:BJ_OPERATION_REFRESH error_message:[result getError] params:nil];
    
    if (operationCallbacks[BJ_OPERATION_REFRESH] != nil)
    {
        operationCallbacks[BJ_OPERATION_REFRESH](self, error, BJ_OPERATION_REFRESH, result);
    }
}

- (void)getMoreCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    id result = taskQueue.result;
    if (error == BJ_ERROR_SUCCESSFULL)
    {
        NSDictionary *_result = [result dictionaryValueForKey:@"result"];
        NSArray *__list = [_result arrayValueForKey:@"list"];
        [_list addObjectsFromArray:__list];
        
        _hasMore = [_result intValueForkey:@"has_more" defaultValue:0] == 1;
        _mTotalNum = (int)[_result intValueForkey:@"total_number" defaultValue:0];
        _mNextCursor = [_result stringValueForKey:@"next_cursor" defaultValue:@""];
        _mPreCursor = [_result stringValueForKey:@"pre_cursor" defaultValue:@""];
        _mAdditional = [_result dictionaryValueForKey:@"additional"];
        
        [self saveCache];
    }
    [self invokeDelegateWithError:error ope:BJ_OPERATION_GET_MORE error_message:[result getError] params:nil];
    
    if (operationCallbacks[BJ_OPERATION_GET_MORE] != nil)
    {
        operationCallbacks[BJ_OPERATION_GET_MORE](self, error, BJ_OPERATION_GET_MORE, result);
    }
}

- (void)addItemCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    id result = taskQueue.result;
    if (error == BJ_ERROR_SUCCESSFULL)
    {
        [self saveCache];
    }
    [self invokeDelegateWithError:error ope:BJ_OPERATION_ADD_ITEM error_message:[result getError] params:nil];
    
    if (operationCallbacks[BJ_OPERATION_ADD_ITEM] != nil)
    {
        operationCallbacks[BJ_OPERATION_ADD_ITEM](self, error, BJ_OPERATION_ADD_ITEM, result);
    }
}

- (void)removeItemCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    id result = taskQueue.result;
    if (error == BJ_ERROR_SUCCESSFULL)
    {
        int index = [taskQueue.param intValue];
        [_list removeObjectAt:index];
        if ([_list count] == 0)
        {
            _status = BJ_STATUS_EMPTY;
        }
        [self saveCache];
    }
    [self invokeDelegateWithError:error ope:BJ_OPERATION_REMOVE_ITEM error_message:[result getError] params:nil];
    
    if (operationCallbacks[BJ_OPERATION_REMOVE_ITEM] != nil)
    {
        operationCallbacks[BJ_OPERATION_REMOVE_ITEM](self, error, BJ_OPERATION_REMOVE_ITEM, result);
    }
}

- (void)saveItemCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    id result = taskQueue.result;
    if(error == BJ_ERROR_SUCCESSFULL)
    {
        [self saveCache];
    }
    [self invokeDelegateWithError:error ope:BJ_OPERATION_SAVE_ITEM error_message:[result getError] params:nil];
    
    if (operationCallbacks[BJ_OPERATION_SAVE_ITEM] != nil)
    {
        operationCallbacks[BJ_OPERATION_SAVE_ITEM](self, error, BJ_OPERATION_SAVE_ITEM, result);
    }
}

- (void)taskQueueFinished:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    BJDATA_OPERATION_CODE ope ;
    if (tasks[BJ_OPERATION_REFRESH] == taskQueue)
    { //callback refresh
        [self refreshCallback:taskQueue param:param error:error];
        ope = BJ_OPERATION_REFRESH;
    }
    else if (tasks[BJ_OPERATION_GET_MORE] == taskQueue)
    {//callback getmore
        [self getMoreCallback:taskQueue param:param error:error];
        ope = BJ_OPERATION_GET_MORE;
    }
    else if (tasks[BJ_OPERATION_ADD_ITEM] == taskQueue)
    { // callback additem
        [self addItemCallback:taskQueue param:param error:error];
        
        ope = BJ_OPERATION_ADD_ITEM;
    }
    else if (tasks[BJ_OPERATION_REMOVE_ITEM] == taskQueue)
    {// callback remove item
        [self removeItemCallback:taskQueue param:param error:error];
        
        ope = BJ_OPERATION_REMOVE_ITEM;
    }
    else if (tasks[BJ_OPERATION_SAVE_ITEM] == taskQueue)
    {//callback save item
        [self saveItemCallback:taskQueue param:param error:error];
        
        ope = BJ_OPERATION_SAVE_ITEM;
    }
    
    [tasks[ope] cleanQueue];
    tasks[ope] = nil;
    
    operationCallbacks[ope] = nil;
}

@end
