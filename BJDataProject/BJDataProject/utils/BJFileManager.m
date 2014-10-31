//
//  BJFileManager.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJFileManager.h"
#import "BJUserAccount.h"

@implementation BJFileManager

+ (NSString *)getCacheFilePath:(NSString *)cache
{
    if (cache == nil)
        return nil;
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", dir, cache];
    
}

+ (void)deleteCacheFile:(NSString *)cache
{
    NSString *filepath = [BJFileManager getCacheFilePath:cache];
    if (filepath == nil) return;
    [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
}

+ (NSString *)getCacheFilePath:(NSString *)cache withAccount:(BJUserAccount *)account
{
    if (cache == nil || account == nil)
        return nil;
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#ifdef DEBUG
    dir = [NSString stringWithFormat:@"%@/debug_%lld", dir, account.personId];
#elif BETA
    dir = [NSString stringWithFormat:@"%@/beta_%lld", dir, account.personId];
#else
    dir = [NSString stringWithFormat:@"%@/%lld", dir, account.personId];
#endif
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    return [NSString stringWithFormat:@"%@/%@", dir, cache];
}

@end
