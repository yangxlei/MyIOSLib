//
//  BJDataFactory.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BJData;
@class BJUserAccount;
/**
 *  Modal 创建使用到的工具类，建议都是用这个方法
 */
@interface BJDataFactory : NSObject

+ (instancetype)shareInstance;

- (BJUserAccount *)chooseUserAccount;

/**
 *  此处，对所有创建出来的 BJData 会有个链表记录。
 *  add 和 remove 会自动处理。上层不需要关心
 *
 *  @param data
 */
- (void)addBJDataIntoLink:(BJData *)data;
- (void)removeBJDataFromLink:(BJData *)data;

/**
 *  通过数据类型找到对应的 BJdata。
 *  <br/>
 *  前提请确认 BJData 在内存中存在。
 *
 *  @param dataType 类型在 BJData 的 getType 方法中定义
 *
 *  @return 如果找到返回对应的 BJData。可能会有多个同类型的，找到的第一个为准.如果会同时创建多个同类的BJData，请区分 getType
 */
- (BJData *)findBJDataWithType:(NSString *)dataType;

/**
 *  对链表中的数据发送消息，可以在任何地方调用
 *
 *  @param dataType 数据类型，如果为 nil 表示所有
 *  @param message  消息内容
 *  @param params   广播需要传递的参数
 */
- (void)boardCastMessage:(NSString *)dataType
                 message:(NSString *)message
                  params:(id)params;

@end
