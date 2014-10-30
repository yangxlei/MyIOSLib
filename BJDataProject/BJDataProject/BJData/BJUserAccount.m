//
//  BJUserAccount.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-18.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJUserAccount.h"
#import "BJFileManager.h"

@interface BJUserAccount()
{
    NSString *_domain;
}

@end

@implementation BJUserAccount

- (id)initWithDomain:(NSString *)domain
{
    self = [super init];
    if (self)
    {
        _domain = [domain copy];
        _person = [[BJPerson alloc] init];
        _person.mAccount = self;
        [self loadCache];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSAssert(0, @"不允许直接调用 init 方法。请调用 initWithDomain");
    }
    return self;
}

- (void)loginWithAccount:(BJUserAccount *)account
{
    [self loginWithPerson:[account personId] token:[account authToken]];
}

- (void)loginWithPerson:(long long)personId token:(NSString *)token
{
    _personId = personId;
    _authToken = token;
    _person.personID = _personId;
    [self saveCache];
    [self invokeDelegateWithError:ERROR_SUCCESSFULL ope:ACCOUNT_LOGIN error_message:nil params:_domain];
}

- (void)logout
{
    [self logoutWithOperation:ACCOUNT_LOGOUT];
}

- (void)logoutWithOperation:(int)ope
{
    _personId = 0;
    _authToken = nil;
    [_person cancelRefresh];
    [BJFileManager deleteCacheFile:[_person getCacheKey]];
    _person.personID = 0;
    
    if ([self getCacheKey])
    {
        [BJFileManager deleteCacheFile:[self getCacheKey]];
    }
    
    //广播， 当前账户退出登陆
    [self invokeDelegateWithError:ERROR_SUCCESSFULL ope:ope error_message:nil params:_domain];
}

- (BOOL)isLogin
{
    return (_authToken != nil && [_authToken length] > 0);
}

- (void)loadCache
{
    //主账户的数据才做缓存
    if([_domain isEqualToString:USER_DOMAIN_MAIN])
    {

        NSString *filepath = [BJFileManager getCacheFilePath:[self getCacheKey]];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
        _hostUrl = [dictionary valueForKey:@"host_url"];
        _appKey = [dictionary valueForKey:@"app_key"];
        if ([_appKey isEqualToString:APP_KEY] && [_hostUrl isEqualToString:HOST_API])
        { //此次登陆和上次登陆的 url 和 key 没有被修改，才能继续使用之前的 token
            _personId = [[dictionary valueForKey:@"person_id"] longLongValue];
            _authToken = [dictionary valueForKey:@"auth_token"];
            
            _person.personID = _personId;
        }
        else
        {
            _hostUrl = nil;
            _appKey = nil;
        }
    }
    
    //初始化 host，key
    if ([_hostUrl length] == 0 && [_appKey length] == 0)
    {
        _hostUrl = HOST_API;
        _appKey = APP_KEY;
    }
}

- (void)saveCache
{
    NSString *filepath = [BJFileManager getCacheFilePath:[self getCacheKey]];
    if (filepath == nil) return;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:_personId],@"person_id", _authToken,@"auth_token",_hostUrl,@"host_url", _appKey,@"app_key", nil];
    [dic writeToFile:filepath atomically:YES];
    
}

- (NSString *)getCacheKey
{
    //主账户的数据才做缓存
    if ([_domain isEqualToString:USER_DOMAIN_MAIN])
    {
        return @"user_account_main";
    }
    return nil;
}

- (NSString *)getType
{
    return [NSString stringWithFormat:@"user_account_%@", _domain];
}

@end
