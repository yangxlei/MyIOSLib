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


@end

@interface NSString(JsonObject)

/**
    字符串转 json
 */
- (id)jsonValue;

@end

@interface NSDictionary(JsonObject)

- (int)intValueForkey:(NSString *)key;
- (long long)longLongValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key;
- (float)floatValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;

@end