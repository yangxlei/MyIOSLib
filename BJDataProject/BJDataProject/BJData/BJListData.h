//
//  BJListData.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJData.h"

@interface BJListData : BJData

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, assign) BJDATA_STATUS_CODE status;

@end
