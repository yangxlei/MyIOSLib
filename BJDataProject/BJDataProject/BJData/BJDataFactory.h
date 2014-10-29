//
//  BJDataFactory.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJData.h"

/**
 *  Modal 创建使用到的工具类，建议都是用这个方法
 */
@interface BJDataFactory : NSObject

+ (instancetype)shareInstance;

- (BJUserAccount *)chooseUserAccount;

@end
