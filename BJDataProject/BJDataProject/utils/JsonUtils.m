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
/**
 *  判断int float bool double 是不是应该返回默认值
 *
 *  @param key key对应的值必须是NSString和NSNumber类型
 *
 *  @return YES\NO
 */
- (BOOL)shouldDefalutValue:(NSString *)key
{
    if ([self jsonTypeForKey:key] == JSON_VALUE_NIL)
        return YES;
    if ([self jsonTypeForKey:key] == JSON_VALUE_NSString ||
        [self jsonTypeForKey:key] == JSON_VALUE_NSNumber)
    {
        NSAssert(0, @"%s,key对应的值不是NSString或者NSNumber类型",__func__);
        return NO;
    }
    else
        return YES;
}

- (int)intValueForkey:(NSString *)key defaultValue:(int)defalutValue
{
    if ([self shouldDefalutValue:key]) {
        return defalutValue;
    }
    else
    {
        id value = [self valueForKey:key];
        return [value intValue];
    }
}

- (long long)longLongValueForKey:(NSString *)key defalutValue:(long long)defalutValue
{
    if ([self shouldDefalutValue:key]) {
        return defalutValue;
    }
    else
    {
        id value = [self valueForKey:key];
        return [value longLongValue];
    }
}

- (BOOL)boolValueForKey:(NSString *)key defalutValue:(BOOL)defalutValue
{
    if ([self shouldDefalutValue:key]) {
        return defalutValue;
    }
    else
    {
        id value = [self valueForKey:key];
        return [value boolValue];
    }
}

- (float)floatValueForKey:(NSString *)key defalutValue:(float)defalutValue
{
    if ([self shouldDefalutValue:key]) {
        return defalutValue;
    }
    else
    {
        id value = [self valueForKey:key];
        return [value floatValue];
    }
}

- (double)doubleValueForKey:(NSString *)key defalutValue:(double)defalutValue
{
    if ([self shouldDefalutValue:key]) {
        return defalutValue;
    }
    else
    {
        id value = [self valueForKey:key];
        return [value doubleValue];
    }
}

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id value = [self valueForKey:key];
    if ([self jsonTypeForKey:key] == JSON_VALUE_NIL)
    {
        return defaultValue;
    }
    else if ([self jsonTypeForKey:key] == JSON_VALUE_NSString)
        return value;
    else
    {
        NSAssert(0, @"%s key对应的类型不是NSString的",__func__);
        return defaultValue;
    }
}

- (NSDictionary *)dictionaryValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([self jsonTypeForKey:key] == JSON_VALUE_NIL)
        return nil;
    
    if (([self jsonTypeForKey:key] != JSON_VALUE_NSDictaionary))
    {
        NSAssert(0, @"%s key对应的类型不是NSDictionary的",__func__);
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:value];
    [self setValue:dic forKey:key];
    
    return dic;
}

- (NSArray *)arrayValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([self jsonTypeForKey:key] == JSON_VALUE_NIL)
        return nil;
    
    if ([self jsonTypeForKey:key] != JSON_VALUE_NSArray)
    {
        NSAssert(0, @"%s key对应的类型不是NSArray的",__func__);
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:value];
    [self setValue:array forKey:key];
    return array;
}

- (void)setIntValue:(int)value forKey:(NSString *)key
{
    if ([self jsonTypeForKey:key] == JSON_Value_NSMutableDictionary)
    {
        [self setValue:[NSNumber numberWithInt:value] forKey:key];
    }
    else
        NSAssert(0, @"%s 当前类不是NSMutableDictionary类型的",__func__);
}

- (void)setLongLongValue:(long long)value forKey:(NSString *)key
{
    if ([self jsonTypeForKey:key] == JSON_Value_NSMutableDictionary)
    {
        [self setValue:[NSNumber numberWithLongLong:value] forKey:key];
    }
    else
        NSAssert(0, @"%s 当前类不是NSMutableDictionary类型的",__func__);
}

- (void)setBoolValue:(long long)value forKey:(NSString *)key
{
    if ([self jsonTypeForKey:key] == JSON_Value_NSMutableDictionary)
    {
        [self setValue:[NSNumber numberWithBool:value] forKey:key];
    }
    else
        NSAssert(0, @"%s 当前类不是NSMutableDictionary类型的",__func__);
}

- (void)setFloatValue:(float)value forKey:(NSString *)key
{
    if ([self jsonTypeForKey:key] == JSON_Value_NSMutableDictionary)
    {
        [self setValue:[NSNumber numberWithFloat:value] forKey:key];
    }
    else
        NSAssert(0, @"%s 当前类不是NSMutableDictionary类型的",__func__);
}

- (void)setDoubleValue:(double)value forKey:(NSString *)key
{
    if ([self jsonTypeForKey:key] == JSON_Value_NSMutableDictionary)
    {
        [(NSMutableDictionary*)self setValue:[NSNumber numberWithDouble:value] forKey:key];
    }
    else
        NSAssert(0, @"%s 当前类不是NSMutableDictionary类型的",__func__);
}

- (JsonValueType)jsonTypeForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return JSON_VALUE_NIL;
    }
    else if ([value isKindOfClass:[NSString class]])
        return JSON_VALUE_NSString;
    else if ([value isKindOfClass:[NSMutableArray class]])
        return JSON_VALUE_NSMutableArray;
    else if ([value isKindOfClass:[NSMutableDictionary class]])
        return JSON_Value_NSMutableDictionary;
    else if ([value isKindOfClass:[NSArray class]])
        return JSON_VALUE_NSArray;
    else if ([value isKindOfClass:[NSDictionary class]])
        return JSON_VALUE_NSDictaionary;
    else if ([value isKindOfClass:[NSNumber class]])
        return JSON_VALUE_NSNumber;
    
    return JSON_VALUE_NIL;
}

- (void)removeValueForKey:(NSString *)key
{
    if ([self jsonTypeForKey:key] == JSON_Value_NSMutableDictionary)
    {
        [(NSMutableDictionary *)self removeObjectForKey:key];
    }
    else
        NSAssert(0, @"%s 当前类不是NSMutableDictionary类型的",__func__);
}

- (void)addObject:(id)object forKey:(NSString *)key
{
    if (!object) {
        return;
    }
    id value = [self arrayValueForKey:key];
    if (value) {
        [value addObject:object];
    }
    else
    {
        NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:object, nil];
        [self setValue:list forKey:key];
    }
}

- (void)insertObjectHead:(id)object forKey:(NSString *)key
{
    if (!object) {
        return;
    }
    id value = [self arrayValueForKey:key];
    if (value) {
        [value insertObject:object atIndex:0];
    }
    else
    {
        NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:object, nil];
        [self setValue:list forKey:key];
    }
}

- (void)removeObjectAt:(NSInteger)index forKey:(NSString *)key
{
    id value = [self arrayValueForKey:key];
    if (value && [value count]>index) {
        [value removeObjectAtIndex:index];
    }
    else
    {
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
