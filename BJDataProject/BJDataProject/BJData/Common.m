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
    BJUserAccount *_anonymousAccount;
    BJUserAccount *_mainAccount;
}
@property (strong, readonly, nonatomic)NSString *app_version;
@property (strong, readonly, nonatomic)NSString *api_version;
@property (strong, readonly, nonatomic)NSString *system_name;
@property (strong, readonly, nonatomic)NSString *system_version;
@property (strong, readonly, nonatomic)NSString *device_uuid;
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
    _app_version = [d objectForKey:@"app_version"];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _anonymousAccount = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_ANONYMOUS];
        _mainAccount = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_MAIN];
        
        [self loadCfg];
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
