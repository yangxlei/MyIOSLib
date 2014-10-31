//
//  BJSimpleData.m
//  BJDataProject
//
//  Created by 杨磊 on 14-9-19.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJSimpleData.h"
#import "BJFileManager.h"
#import "JsonUtils.h"

@interface BJSimpleData()
{
    simpleDataOperationCallback _operationCallback;
}

@end

@implementation BJSimpleData
@synthesize data=_data;

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (NSMutableDictionary *)data
{
    if (_data == nil)
    {
        _data = [[NSMutableDictionary alloc] init];
    }
    
    return _data;
}

- (void)setData:(NSMutableDictionary *)data
{
    _data = data;
    [self saveCache];
}

- (void)saveCache
{
    NSString *filePath = [BJFileManager getCacheFilePath:[self getCacheKey] withAccount:self.mAccount];
    if (filePath == nil)
        return;
    NSError *error = nil;
    BOOL succ = [[JsonUtils jsonToString:_data] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"write file succ %d", succ);
    
    
}

- (void)loadCache
{
    NSString *filePath = [BJFileManager getCacheFilePath:[self getCacheKey] withAccount:self.mAccount];
    if (filePath == nil) return;
    
    NSString *source = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    _data = [source jsonValue];
}

- (void)refresh
{
    if (_taskQueue != nil)
    { // 正在刷新，直接跳过
        return;
    }
    
    _taskQueue = [[TaskQueue alloc] init];
    //子类去添加具体的任务
    [self doRefreshOperation:_taskQueue];
    
    _taskQueue.delegate = self;
    [_taskQueue start:nil];
}

- (void)refresh:(simpleDataOperationCallback)operationCallback
{
    [self refresh];
    _operationCallback = operationCallback;
}

- (void)cancelRefresh
{
    if (_taskQueue == nil)
    { // 没有在刷新
        return;
    }
    
    [_taskQueue cancelQueue];
    _taskQueue = nil;
}

- (void)doRefreshOperation:(TaskQueue *)taskQueue
{
}

- (void)taskQueueFinished:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    if (error == ERROR_SUCCESSFULL)
    {
        id _result = [taskQueue.result dictionaryValueForKey:@"result"];
        // 获取结果数据
        if (_result != nil)
        {
            _data = _result;
            [self saveCache];
        }
    }
    
    [self invokeDelegateWithError:error ope:OPERATION_REFRESH error_message:[taskQueue.result getError] params:nil];
    
    if (_operationCallback)
    {
        _operationCallback(self, error, OPERATION_REFRESH, taskQueue.result);
    }
    
    _operationCallback = nil;
    
    [_taskQueue cleanQueue];
    _taskQueue = nil;
}

@end
