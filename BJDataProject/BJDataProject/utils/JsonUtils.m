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

+ (id)newJsonObject:(BOOL)array
{
    if (array)
    {
        return (id)[[NSMutableArray alloc] init];
    }
    else
    {
        return (id)[[NSMutableDictionary alloc] init];
    }
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

- (int)intValueForkey:(NSString *)key default:(int)_default
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return _default;
    }
    return [value intValue];
}

- (long long)longLongValueForKey:(NSString *)key defalut:(long long)_default
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return _default;
    }
    return [value longLongValue];
}

- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)_default
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return _default;
    }
    return [value boolValue];
}

- (float)floatValueForKey:(NSString *)key default:(float)_default
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return _default;
    }
    return [value floatValue];
}

- (double)doubleValueForKey:(NSString *)key default:(double)_default
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return _default;
    }
    return [value doubleValue];
}

- (void)setIntValue:(int)value forKey:(NSString *)key
{
    if ([self isKindOfClass:[NSMutableDictionary class]])
    {
        [self setValue:[NSNumber numberWithInt:value] forKey:key];
    }
}

- (void)setLongLongValue:(long long)value forKey:(NSString *)key
{
    if ([self isKindOfClass:[NSMutableDictionary class]])
    {
        [self setValue:[NSNumber numberWithLongLong:value] forKey:key];
    }
}

- (void)setBoolValue:(long long)value forKey:(NSString *)key
{
    if ([self isKindOfClass:[NSMutableDictionary class]])
    {
        [self setValue:[NSNumber numberWithBool:value] forKey:key];
    }
}

- (void)setFloatValue:(float)value forKey:(NSString *)key
{
    if ([self isKindOfClass:[NSMutableDictionary class]])
    {
        [self setValue:[NSNumber numberWithFloat:value] forKey:key];
    }
}

- (void)setDoubleValue:(double)value forKey:(NSString *)key
{
    if ([self isKindOfClass:[NSMutableDictionary class]])
    {
        [self setValue:[NSNumber numberWithDouble:value] forKey:key];
    }
}

- (NSString *)getError
{
    NSString *message = [self valueForKey:@"message"];
    if (message == nil)
    {
        return @"现在连不上网络，请稍后重试";
    }
    return message;
}

@end
