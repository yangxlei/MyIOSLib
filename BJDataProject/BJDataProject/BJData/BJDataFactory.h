//
//  BJDataFactory.h
//  BJDataProject
//
//  Created by 杨磊 on 14-9-6.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJData.h"

@interface BJDataFactory : NSObject
{
    BJData      *_dataList;
}

/**
    统一创建 BJData 方法
 @param type 数据类型
 */
- (BJData *)createData:(NSString *)type;

- (void)findData;
@end
