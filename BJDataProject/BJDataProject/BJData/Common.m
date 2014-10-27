//
//  Common.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-26.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "Common.h"

@interface Common()
{
    BJUserAccount *_anonymousAccount;
    BJUserAccount *_mainAccount;
}

@end

@implementation Common

+ (Common *)shareInstance
{
    static Common *instance = nil;
    if (instance) return instance;
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[Common alloc] init];
        }
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _anonymousAccount = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_ANONYMOUS];
        _mainAccount = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_MAIN];
    }
    
    return self;
}

- (BJUserAccount *)getAnonymousAccount
{
    return _anonymousAccount;
}

- (BJUserAccount *)getMainAccount
{
    return _mainAccount;
}

@end
