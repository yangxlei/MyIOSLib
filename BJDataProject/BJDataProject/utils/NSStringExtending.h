
#import <Foundation/Foundation.h>


@interface NSString (NSStringExtending)

+ (id)stringWithUTF8String:(const char *)bytes defaultValue:(NSString *)defaultValue;

@end
