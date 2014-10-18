//
//  BJDataFactory.m
//  BJDataProject
//
//  Created by 杨磊 on 14-9-6.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJDataFactory.h"

@implementation BJDataFactory

- (id)init
{
    self = [super init];
    {
        _dataList = [[BJData alloc] init];
    }
    return self;
}

- (BJData *)createData:(NSString *)type
{
    return nil;
}

- (void)findData
{
}

@end
