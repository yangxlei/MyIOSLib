//
//  BJDataFactory.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJDataFactory.h"
#import "Common.h"

@implementation BJDataFactory

+ (instancetype)shareInstance
{
    static BJDataFactory *factory = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        factory = [[self alloc] init];
    });
    return factory;
}

- (BJUserAccount *)chooseUserAccount
{
    BJUserAccount *account = CommonInstance.mainAccount;
    if (account == nil)
    {
        account = CommonInstance.anonymousAccount;
    }
    return account;
}

@end
