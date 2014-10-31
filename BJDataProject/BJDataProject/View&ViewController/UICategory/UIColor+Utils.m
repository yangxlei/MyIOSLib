//
//  UIColor+Utils.m
//  BJDataProject
//
//  Created by Randy on 14/10/30.
//  Copyright (c) 2014年 Randy. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)
+ (UIColor*)colorWithARGB_Utils:(NSUInteger)argb
{
    CGFloat red = (argb>>16)&0xFF;
    CGFloat green = (argb>>8)&0xFF;
    CGFloat blue = argb&0xFF;
    CGFloat alpha = 255;
    if (argb > 0xFFFFFF)
    {
        alpha = (argb>>24)&0xFF;
    }
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}
@end
