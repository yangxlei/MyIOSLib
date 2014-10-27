//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "SvUDIDTools.h"
#import "NSString+MD5Addition.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice(Private)

- (NSString *) macaddress;

@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash stringFromMD5];
    
    return uniqueIdentifier;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    return [SvUDIDTools UDID];
}

+ (NSString *)platformString
{
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
    return platform;
}

+ (NSString* )platformName
{
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *deviceString = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);

    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5(AT&T)";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5(GSM/CDMA)";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    //Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    return @"unknow";
}

+ (BOOL)isLowDevice
{
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *deviceString = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return YES;
    if ([deviceString isEqualToString:@"iPhone1,2"])    return YES;
    if ([deviceString isEqualToString:@"iPhone2,1"])    return YES;
    if ([deviceString isEqualToString:@"iPhone3,1"])    return YES;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return YES;
    //if ([deviceString isEqualToString:@"iPhone4,1"])    return NO;
    //if ([deviceString isEqualToString:@"iPhone5,1"])    return NO;
    //if ([deviceString isEqualToString:@"iPhone5,2"])    return NO;
    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return YES;
    if ([deviceString isEqualToString:@"iPod2,1"])      return YES;
    if ([deviceString isEqualToString:@"iPod3,1"])      return YES;
    if ([deviceString isEqualToString:@"iPod4,1"])      return YES;
    //if ([deviceString isEqualToString:@"iPod5,1"])      return NO;
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return YES;
    if ([deviceString isEqualToString:@"iPad2,1"])      return YES;
    if ([deviceString isEqualToString:@"iPad2,2"])      return YES;
    if ([deviceString isEqualToString:@"iPad2,3"])      return YES;
    //if ([deviceString isEqualToString:@"iPad2,5"])      return NO;
    //if ([deviceString isEqualToString:@"iPad2,6"])      return NO;
    //if ([deviceString isEqualToString:@"iPad2,7"])      return NO;
    if ([deviceString isEqualToString:@"iPad3,1"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,2"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,3"])      return YES;
    //if ([deviceString isEqualToString:@"iPad3,4"])      return NO;
    //if ([deviceString isEqualToString:@"iPad3,5"])      return NO;
    //if ([deviceString isEqualToString:@"iPad3,6"])      return NO;
    //Simulator
    //if ([deviceString isEqualToString:@"i386"])         return NO;
    //if ([deviceString isEqualToString:@"x86_64"])       return NO;
    
    return NO;
}

+ (BOOL)iphone5Screen
{
    //UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize si = [UIScreen mainScreen].bounds.size;
        if (si.width == 320 && si.height == 568)
        {
            return YES;
        }
    }
    return NO;
}

+(BOOL) isIos7
{
  CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
  return version >= 7.0f;
}


//+ (BOOL)hasMicrophone
//{
//    size_t size;
//	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//	char *machine = malloc(size);
//	sysctlbyname("hw.machine", machine, &size, NULL, 0);
//	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//	free(machine);
//	
//    if ([platform isEqualToString:@"iPhone1,1"]) return YES;
//	if ([platform isEqualToString:@"iPhone1,2"]) return YES;
//	if ([platform isEqualToString:@"iPhone2,1"]) return YES;
//	if ([platform isEqualToString:@"iPhone3,1"]) return YES;
//	return NO;
//}
@end
