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
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            return [[NSMutableDictionary alloc] initWithDictionary:object];
        }
        else if ([object isKindOfClass:[NSArray class]])
        {
            return [[NSMutableArray alloc] initWithArray:object];
        }
        else
        {
            return object;
        }
    }
    return nil;
}

+ (id)convertJsonObject:(id)jsonObject
{
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        return [[NSMutableDictionary alloc] initWithDictionary:jsonObject];
    }
    else if ([jsonObject isKindOfClass:[NSArray class]])
    {
        return [[NSMutableArray alloc] initWithArray:jsonObject];
    }
    else
    {
        return jsonObject;
    }
        
    
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
        if ([result isKindOfClass:[NSDictionary class]])
        {
            return [[NSMutableDictionary alloc] initWithDictionary:result];
        }
        else if ([result isKindOfClass:[NSArray class]])
        {
            return [[NSMutableArray alloc] initWithArray:result];
        }
        else
        {
            return result;
        }
    }
    return nil;
}
@end

@implementation NSDictionary(JsonObject)

- (int)intValueForkey:(NSString *)key defaultValue:(int)defalutValue
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return defalutValue;
    }
    return [value intValue];
}

- (long long)longLongValueForKey:(NSString *)key defalutValue:(long long)defalutValue
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return defalutValue;
    }
    return [value longLongValue];
}

- (BOOL)boolValueForKey:(NSString *)key defalutValue:(BOOL)defalutValue
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return defalutValue;
    }
    return [value boolValue];
}

- (float)floatValueForKey:(NSString *)key defalutValue:(float)defalutValue
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return defalutValue;
    }
    return [value floatValue];
}

- (double)doubleValueForKey:(NSString *)key defalutValue:(double)defalutValue
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return defalutValue;
    }
    return [value doubleValue];
}

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id value = [self valueForKey:key];
    if (value == nil)
    {
        return defaultValue;
    }
    
    return value;
}

- (NSDictionary *)dictionaryValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if (value == nil)
        return nil;
    
    if (![value isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:value];
    [self setValue:dic forKey:key];
    
    return dic;
}

- (NSArray *)arrayValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if (value == nil)
        return nil;
   
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:value];
    [self setValue:array forKey:key];
    return array;
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
        [(NSMutableDictionary*)self setValue:[NSNumber numberWithDouble:value] forKey:key];
    }
}

- (void)removeValueForKey:(NSString *)key
{
    if ([self isKindOfClass:[NSMutableDictionary class]])
    {
        [(NSMutableDictionary *)self removeObjectForKey:key];
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

@implementation NSArray(JsonObject)

- (void)addObject:(id)object
{
    if ([self isKindOfClass:[NSMutableArray class]])
    {
        [(NSMutableArray*)self insertObject:object atIndex:[self count]];
    }
}

- (void)insertobjectHead:(id)object
{
    if ([self isKindOfClass:[NSMutableArray class]])
    {
        [(NSMutableArray*)self insertObject:object atIndex:0];
    }
}

- (void)removeObjectAt:(NSInteger)index
{
    if ([self isKindOfClass:[NSMutableArray class]])
    {
        [(NSMutableArray*)self removeObjectAtIndex:index];
    }
}

@end
