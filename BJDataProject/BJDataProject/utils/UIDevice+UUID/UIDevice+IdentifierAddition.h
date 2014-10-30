//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (IdentifierAddition)

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;


//获得设备的识别码如"iPhone1,1"，"iPhone1,2"
+ (NSString *) platformString;


//获得设备的名称，如"iPhone 5(AT&T)"，"iPad Mini (CDMA)"等
+ (NSString* )platformName;


//是否是性能较差的设备
+ (BOOL)isLowDevice;

//是否是iphone的屏幕尺寸
+ (BOOL)iphone5Screen;

+(BOOL) isIos7;
@end
