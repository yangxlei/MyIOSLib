//
//  BJUserAccount.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-18.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJData.h"
#import "BJPerson.h"

#define USER_DOMAIN_ANONYMOUS @"anonymouns"
#define USER_DOMAIN_MAIN  @"main"

#define APP_KEY  @"Fohqu0bo"

#ifdef DEBUG
#define HOST_API @"http://test-appapi.genshuixue.com"
#elif BETA
#define HOST_API @"http://beta-tapi.genshuixue.com"
#else
#define HOST_API @"http://tapi.genshuixue.com"
#endif

#define API_GET_ANONYMOUS_TOKEN @"/auth/anonymous"

enum _account_ope
{
    BJ_ACCOUNT_LOGIN = 11,
    BJ_ACCOUNT_LOGOUT = 12,
}BJ_ACCOUNT_OPERATION;

@interface BJUserAccount : BJData

//@property (nonatomic, strong, readonly) NSString *domain;
@property (nonatomic, assign, readonly) long long personId;
@property (nonatomic, strong, readonly) NSString *authToken;
@property (nonatomic, strong, readonly) NSString *hostUrl;
@property (nonatomic, strong, readonly) NSString *appKey;

@property (nonatomic, strong, readonly) BJPerson *person; // 当前账户对应的 person 信息,创建会自动刷新

/**
    初始化，表明当前账户类型
    @param domain, 分为匿名账户，和正常使用的主账户
 */
- (id)initWithDomain:(NSString *)domain;


- (void)loginWithPerson:(long long)personId token:(NSString *)token;
- (void)loginWithAccount:(BJUserAccount *)account;

- (void)logout;
/**
 *  退出账户, 指定操作来源。 例如：BJ_ACCOUNT_LOGOUT 表示主动退出
 *
 *  @param ope 操作
 */
- (void)logoutWithOperation:(int)ope;

- (BOOL) isLogin;

@end
