//
//  BJDataDelegate.h
//  BJDataProject
//
//  Created by 杨磊 on 14-9-13.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BJData;
@protocol BJDataDelegate <NSObject>

/**
 @desc 数据代理回调方法，用于监听数据变化
 @param _data 数据源
 @param _error 操作结果状态
 @param _ope   操作类型
 @param _error_message  错误消息
 @param params  回调时传递的参数
 */
- (void)dataEvent:(BJData *)_data
            error:(int)_error
              ope:(int)_ope
    error_message:(NSString *)_error_message
           params:(id)params;

@end
