//
//  APIManager.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    接口管理器，所有接口请求
    包含功能：
    0、接口请求队列
    1、正常的 Get， Post
    2、任务请求的取消
    3、接口 url 的拼装，签名
    4、所有请求返回统一管理, 判断当前请求状态（单点，token失效等）
    5、匿名 token 的获取
 */
@interface APIManager : NSObject

@end