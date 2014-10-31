
#import "NSStringExtending.h"


@implementation NSString (NSStringExtending)

+ (id)stringWithUTF8String:(const char *)bytes defaultValue:(NSString *)defaultValue
{
    if (bytes && strlen(bytes))
    {
        return [NSString stringWithUTF8String:bytes];
    }
    return defaultValue;    
}


@end
