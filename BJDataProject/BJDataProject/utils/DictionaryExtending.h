//
//  DictionaryExtending.h
//  Test
//
//  Created by zhang yan on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (DictionaryExtending)

- (void)setIntValue:(int)intValue forKey:(NSString *)key;

- (void)setUIntValue:(unsigned int)intValue forKey:(NSString *)key;

- (void)setBoolValue:(BOOL)boolValue forKey:(NSString *)key;

- (void)setFloatValue:(float)floatValue forKey:(NSString *)key;

- (void)setLongValue:(long)longValue forKey:(NSString *)key;

- (void)setLongLongValue:(long long)longLongValue forKey:(NSString *)key;

- (void)setRect:(CGRect)rect forKey:(NSString *)key;

- (void)setEdgeInsert:(UIEdgeInsets)insert forKey:(NSString*)key;

- (void)setSize:(CGSize)si forKey:(NSString *)key;

- (void)setPoint:(CGPoint)point forKey:(NSString*)key;

- (void)setCString:(const char *)cString forKey:(NSString *)key;

- (void)setSelector:(SEL)selector forKey:(NSString *)key;


@end



@interface NSDictionary (DictionaryExtending)

- (BOOL)hasValueForKey:(NSString *)key;

- (int)intValueForKey:(NSString *)key;

- (unsigned int)uintValueForKey:(NSString *)key;

- (BOOL)boolValueForKey:(NSString *)key;

- (float)floatValueForKey:(NSString *)key;

- (long)longValueForKey:(NSString *)key;

- (long long)longLongValueForKey:(NSString *)key;

- (CGRect)rectValueForKey:(NSString *)key;

- (UIEdgeInsets)edgeInserForKey:(NSString*)key;

- (CGPoint)pointValueForKey:(NSString*)key;

- (CGSize)sizeValueForKey:(NSString*)key;

- (const char *)cStringForKey:(NSString *)key; //The returned C string is automatically freed just as a returned object would be released; you should copy the C string if it needs to store it outside of the autorelease context in which the C string is created.

- (SEL)selectorForKey:(NSString *)key;

@end
