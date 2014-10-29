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

@end
