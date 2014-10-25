//
//  TestTaskItem2.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "TestTaskItem2.h"

@implementation TestTaskItem2

- (int)DoTask
{
        __weak typeof(self) tempSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            sleep(3);
            NSLog(@"*************DOTask2 Background ********************");
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [tempSelf TaskCompleted:1 result:nil];
            });
        });
    return 2;
}

@end
