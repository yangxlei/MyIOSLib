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
@property (strong, readonly, nonatomic)NSString *app_version;
@property (strong, readonly, nonatomic)NSString *api_version;
@property (strong, readonly, nonatomic)NSString *system_name;
@property (strong, readonly, nonatomic)NSString *system_version;
@property (strong, readonly, nonatomic)NSString *device_uuid;

+ (Common *)shareInstance;

- (BJUserAccount *)getAnonymousAccount;
- (BJUserAccount *)getMainAccount;

@end
