//
//  BJSimpleCacheData.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJSimpleData.h"

/**
 * 待过期时间的 Data 类型
 */
@interface BJSimpleCacheData : BJSimpleData

/**
 *  由子类自己设置当前数据的过期时间
 *
 *  @return 返回过期时间，单位秒
 */
- (long)dataCacheTime;

@end
