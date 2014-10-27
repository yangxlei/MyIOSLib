//
//  APITask.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "TaskItem.h"

/**
 做 api 请求任务
 
 :param: instancetypeinitWithAPI <#instancetypeinitWithAPI description#>
 */
@interface APITask : TaskItem

/**
 *  通过 GET 方式请求
 *
 *  @param api
 *
 *  @return
 */
- (instancetype)initWithAPI:(NSString *)api;

/**
 *  通过 POST 方式请求
 *
 *  @param api
 *  @param postBody
 *
 *  @return 
 */
- (instancetype)initWithAPI:(NSString *)api
                   postBody:(NSDictionary *)postBody;

@end
