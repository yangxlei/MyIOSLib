//
//  JsonUtils.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "JsonUtils.h"

@implementation JsonUtils

+ (NSData *)encode:(id)json
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil)
        return jsonData;
    return nil;
}

+ (NSString *)jsonToString:(id)json
{
    NSData *data = [JsonUtils encode:json];
    if (data)
    {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (id)decode:(NSData *)data
{
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (object != nil && error == nil)
        return object;
    return nil;
}

@end

@implementation NSString(JsonObject)

- (id)jsonValue
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (result != nil && error == nil)
    {
        return result;
    }
    return nil;
}
@end

@implementation NSDictionary(JsonObject)

- (int)intValueForkey:(NSString *)key
{
    id value = [self valueForKey:key];
    return [value intValue];
}

- (long long)longLongValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    return [value longLongValue];
}

- (BOOL)boolValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    return [value boolValue];
}

- (float)floatValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    return [value floatValue];
}

- (double)doubleValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    return [value doubleValue];
}

@end
