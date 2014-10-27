//
//  Common.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-26.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJUserAccount.h"

/**
 *  全局单例，保存一些全局有效的对象
 */
@interface Common : NSObject

+ (Common *)shareInstance;

- (BJUserAccount *)getAnonymousAccount;
- (BJUserAccount *)getMainAccount;

@end
