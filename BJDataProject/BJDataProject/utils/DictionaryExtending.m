//
//  DictionaryExtending.m
//  Test
//
//  Created by zhang yan on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DictionaryExtending.h"


@implementation NSMutableDictionary (DictionaryExtending)

- (void)setIntValue:(int)intValue forKey:(NSString *)key
{
    if (key)
    {
        [self setValue:[NSNumber numberWithInt:intValue] forKey:key];
    }
}

- (void)setUIntValue:(unsigned int)intValue forKey:(NSString *)key
{
    if (key)
    {
        [self setValue:[NSNumber numberWithUnsignedInt:intValue] forKey:key];
    }
}

- (void)setBoolValue:(BOOL)boolValue forKey:(NSString *)key
{
    if (key)
    {
        [self setValue:[NSNumber numberWithBool:boolValue] forKey:key];
    }
}

- (void)setFloatValue:(float)floatValue forKey:(NSString *)key;
{
    if (key)
    {
        [self setValue:[NSNumber numberWithFloat:floatValue] forKey:key];
    }
}

- (void)setLongValue:(long)longValue forKey:(NSString *)key
{
    if (key)
    {
        [self setValue:[NSNumber numberWithLong:longValue] forKey:key];
    }
}

- (void)setLongLongValue:(long long)longLongValue forKey:(NSString *)key
{
    if (key)
    {
        [self setValue:[NSNumber numberWithLongLong:longLongValue] forKey:key];
    }
}

- (void)setRect:(CGRect)rect forKey:(NSString *)key
{
    if (key)
    {
        CFDictionaryRef dictionaryRef = CGRectCreateDictionaryRepresentation(rect);
        if (dictionaryRef)
        {
            [self setValue:(__bridge NSDictionary *)dictionaryRef forKey:key];
            CFRelease(dictionaryRef);
        }
    }
}

- (void)setEdgeInsert:(UIEdgeInsets)insert forKey:(NSString*)key
{
    if (key)
    {
        NSValue* value = [NSValue valueWithUIEdgeInsets:insert];
        if (value)
        {
            [self setValue:value forKey:key];
        }
    }
}

- (void)setPoint:(CGPoint)point forKey:(NSString*)key
{
    if (key)
    {
        CFDictionaryRef dictionaryRef = CGPointCreateDictionaryRepresentation(point);
        if (dictionaryRef)
        {
            [self setValue:(__bridge NSDictionary*)dictionaryRef forKey:key];
            CFRelease(dictionaryRef);
        }
    }
}

- (void)setSize:(CGSize)si forKey:(NSString *)key
{
    if (key)
    {
        CFDictionaryRef dictionaryRef = CGSizeCreateDictionaryRepresentation(si);
        if (dictionaryRef)
        {
            [self setValue:(__bridge NSDictionary*)dictionaryRef forKey:key];
            CFRelease(dictionaryRef);
        }
    }
}

- (void)setCString:(const char *)cString forKey:(NSString *)key
{
    if (key)
    {
        if (cString)
        {
            [self setValue:[NSString stringWithUTF8String:cString] forKey:key];
        }
        else
        {
            [self setValue:nil forKey:key];
        }
    }
}

- (void)setSelector:(SEL)selector forKey:(NSString *)key
{
    if (key)
    {
        if (selector)
        {
            [self setCString:sel_getName(selector) forKey:key];
        }
    }
    
}


@end



@implementation NSDictionary (DictionaryExtending)

- (BOOL)hasValueForKey:(NSString *)key
{
    
    BOOL hasValue = FALSE;
    if (key)
    {
        if ([self valueForKey:key])
        {
            hasValue = TRUE;
        }
    }
    
    return hasValue;
}


- (int)intValueForKey:(NSString *)key
{
    int intValue = 0;
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(intValue)])
        {
            intValue = [object intValue];
        }
    }
    return intValue;
}

- (unsigned int)uintValueForKey:(NSString *)key
{
    unsigned int intValue = 0;
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(unsignedIntValue)])
        {
            intValue = [object unsignedIntValue];
        }
    }
    return intValue;
}

- (BOOL)boolValueForKey:(NSString *)key
{
    BOOL boolValue = FALSE;
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(boolValue)])
        {
            boolValue = [object boolValue];
        }
    }
    return boolValue;
}

- (float)floatValueForKey:(NSString *)key
{
    float floatValue = 0.0;
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(floatValue)])
        {
            floatValue = [object floatValue];
        }
    }
    return floatValue;
}

- (long)longValueForKey:(NSString *)key
{
    long longValue = 0;
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(longValue)])
        {
            longValue = [object longValue];
        }
    }
    return longValue;
}

- (long long)longLongValueForKey:(NSString *)key
{
    long long longLongValue = 0;
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(longLongValue)])
        {
            longLongValue = [object longLongValue];
        }
    }
    return longLongValue;
}

- (CGRect)rectValueForKey:(NSString *)key
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object isKindOfClass:[NSDictionary class]])
        {
            bool result = false;
            result = CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)object, &rect);
            if (!result)
            {
                rect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
            }
        }
    }
    return rect;
}

- (UIEdgeInsets)edgeInserForKey:(NSString*)key
{
    UIEdgeInsets insert = UIEdgeInsetsMake(0, 0, 0, 0);
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object isKindOfClass:[NSValue class]])
        {
            insert = [object UIEdgeInsetsValue];
        }
    }
    return insert;
}

- (CGPoint)pointValueForKey:(NSString*)key
{
    CGPoint point = CGPointMake(0.0f, 0.0f);
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object isKindOfClass:[NSDictionary class]])
        {
            bool result = false;
            result = CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)object, &point);
            if (!result)
            {
                point = CGPointMake(0.0f, 0.0f);
            }
        }
    }
    return point;
}

- (CGSize)sizeValueForKey:(NSString*)key
{
    CGSize si = CGSizeMake(0.0f, 0.0f);
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object isKindOfClass:[NSDictionary class]])
        {
            bool result = false;
            result = CGSizeMakeWithDictionaryRepresentation((CFDictionaryRef)object, &si);
            if (!result)
            {
                si = CGSizeMake(0.0f, 0.0f);
            }
        }
    }
    return si;
}

- (const char *)cStringForKey:(NSString *)key
{
    const char *cString = NULL;
    if (key)
    {
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(UTF8String)])
        {
            cString = [object UTF8String];
        }
    }
    
    return cString;
    
}

- (SEL)selectorForKey:(NSString *)key
{
    SEL selector = NULL;
    const char *name = [self cStringForKey:key];
    if (name) 
    {
        selector = sel_registerName(name);
    }
    return selector;
}


@end
