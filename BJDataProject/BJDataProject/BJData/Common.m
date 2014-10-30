//
//  Common.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-26.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "Common.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import "UIDevice+IdentifierAddition.h"

@interface Common()
{
    NSMutableDictionary *dictionary;
}

@end

@implementation Common

+ (Common *)shareInstance
{
    static Common *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    });
   
    return instance;
}

- (void)loadCfg
{
    size_t size;
    sysctlbyname("hw.machine",NULL,&size,NULL,0);
    char name[2048];
    sysctlbyname("hw.machine", name, &size,NULL,0);
    _system_version = [UIDevice currentDevice].systemVersion;
    _system_name = [NSString stringWithUTF8String:name];
    _device_uuid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* url = [mainBundle pathForResource:@"ex" ofType:@"plist"];
    NSDictionary * d = [NSDictionary dictionaryWithContentsOfFile:url];
    
    _api_version = [d objectForKey:@"api_ver"];
    _app_channel = [d objectForKey:@"channel"];
    _is_company  = [[d objectForKey:@"company"] boolValue];
    
    _app_version = [[mainBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _app_build_version = [[mainBundle infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadCfg];
        dictionary = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"Common dealloc");
}

- (BJUserAccount *)mainAccount
{
    if ([dictionary valueForKey:@"create_main"] != nil && [dictionary valueForKey:@"main"] == nil)
    { //表示 main account 正在创建，就被调用。直接返回 nil。这种情况只在 BJPerson 中会出现
        return nil;
    }

    if ([dictionary objectForKey:@"main"] == nil)
    {
        [dictionary setObject:@"create" forKey:@"create_main"];
        BJUserAccount *_mainAccount = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_MAIN];
        [dictionary setObject:_mainAccount forKey:@"main"];
        [dictionary removeObjectForKey:@"create_main"];
        
        [_mainAccount.person refresh];
        
    }
    return [dictionary objectForKey:@"main"];
}

- (BJUserAccount *)anonymousAccount
{
    if ([dictionary valueForKey:@"create_anony"] != nil && [dictionary valueForKey:@"anonymous"] == nil)
    {
        return nil;
    }

    if ([dictionary objectForKey:@"anonymous"] == nil)
    {
         [dictionary setObject:@"create" forKey:@"create_anony"];
        BJUserAccount *_anonymousAccount = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_ANONYMOUS];
        [dictionary setObject:_anonymousAccount forKey:@"anonymous"];
        [dictionary removeObjectForKey:@"create_anony"];
    }
    return [dictionary objectForKey:@"anonymous"];
}


@end
