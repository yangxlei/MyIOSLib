//
//  JsonUtils.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject


/**
    将 dictionary 或者 array 转位 Json Data
 */
+ (NSData *)encode:(id)json;

+ (NSString *)jsonToString:(id)json;

/**
    将 json data 转为 dictionary 或者 array
 */
+ (id)decode:(NSData *)data;

+ (id)newJsonObject:(BOOL)array;


@end

@interface NSString(JsonObject)

/**
    字符串转 json
 */
- (id)jsonValue;

@end

@interface NSDictionary(JsonObject)

- (int)intValueForkey:(NSString *)key default:(int)_default;
- (long long)longLongValueForKey:(NSString *)key defalut:(long long)_default;
- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)_default;
- (float)floatValueForKey:(NSString *)key default:(float)_default;
- (double)doubleValueForKey:(NSString *)key default:(double)_default;

- (void)setIntValue:(int)value forKey:(NSString *)key;
- (void)setLongLongValue:(long long)value forKey:(NSString *)key;
- (void)setBoolValue:(long long)value forKey:(NSString *)key;
- (void)setFloatValue:(float)value forKey:(NSString *)key;
- (void)setDoubleValue:(double)value forKey:(NSString *)key;


- (NSString *)getError;

@end