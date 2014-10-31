//
//  BJListData.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJData.h"
#import "TaskQueue.h"

@class BJListData;
/**
 *  操作回调用的 block
 *
 *  @param listData 操作的 ListData， 此时回调的 listData已经处理完数据
 *  @param err      本次操作的返回码
 *  @param ope      本次操作的类型
 *  @param result   本次操作的到得结果，只用来看， 不需要再往 listData 里面添加
 */
typedef void (^listDataOperationCallback)(BJListData *listData, int err, int ope, id result);

/**
 *  列表数据模型
 *  功能(PS:逻辑中做了判断，只能同时执行一个操作)：
        1、刷新
        2、加载更多
        3、增加一项
        4、删除一项
        5、修改后保存一项
 */
@interface BJListData : BJData<TaskQueueDelegate>

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, assign) BJDATA_STATUS_CODE status;

@property (nonatomic, strong) id mAdditional;


/**
 *  刷新列表，完成后所有数据都会是全新的
 */
- (void)refresh;
/**
 *  刷新操作，操作完成会回调 block
 *
 *  @param operationCallback 
 */
- (void)refresh:(listDataOperationCallback)operationCallback;
- (void)doRefreshOperation:(TaskQueue *)taskQueue;
/**
 *  刷新完成被调用
 *
 *  @param taskQueue 刷新操作队列
 *  @param param    启动时传递的参数
 *  @param error     结果码
 */
- (void)refreshCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error;

/**
 *  加载更多
 */
- (void)getMore;
- (void)getMore:(listDataOperationCallback)operationCallback;
- (void)doGetMoreOperation:(TaskQueue *)taskQueue;
- (void)getMoreCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error;

/**
 *  判断是否还有更多的数据
 *
 *  @return
 */
- (BOOL)hasMore;

/**
 *  添加一项
 *
 *  @param index 加到哪个位置
 *
 *  @return 操作是否成功
 */
- (BOOL)addItem:(id)item at:(NSInteger)index;
- (BOOL)addItem:(id)item at:(NSInteger)index block:(listDataOperationCallback)operationCallback;
- (void)doAddItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index; //子类实现
- (void)addItemCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error;

/**
 *  删除某一项
 *
 *  @param index 删除项位置
 *
 *  @return 操作是否成功
 */
- (BOOL)removeItem:(NSInteger)index;
- (BOOL)removeItem:(NSInteger)index block:(listDataOperationCallback)operationCallback;
- (void)doRemoveItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index;
- (void)removeItemCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error;

/**
 *  修改过某一项内容之后，保存
 *
 *  @param index  
 *
 *  @return 保存是否成功
 */
- (BOOL)saveItem:(NSInteger)index;
- (BOOL)saveItem:(NSInteger)index block:(listDataOperationCallback)operationCallback;
- (void)doSaveItemOperation:(TaskQueue *)taskQueue at:(NSInteger)index;
- (void)saveItemCallback:(TaskQueue *)taskQueue param:(id)param error:(int)error;

/**
 *  判断是否正在执行某个操作
 *
 *  @param ope 操作码
 *
 *  @return
 */
- (BOOL)isOperation:(BJDATA_OPERATION_CODE)ope;

/**
 *  取消某个操作执行
 *
 *  @param ope 
 */
- (void)cancelOperation:(BJDATA_OPERATION_CODE)ope;

/**
 *  清除列表的所有数据, 在 dealloc 中调用. 或者在外部主动退出的时候调用
 */
- (void)cleanList;

@end
