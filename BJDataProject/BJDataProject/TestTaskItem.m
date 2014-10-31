//
//  TestTaskItem.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-25.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "TestTaskItem.h"
#import <AFNetworking.h>
#import "BJData.h"

@implementation TestTaskItem

- (int)DoTask
{
    
    __weak typeof(self) tempSelf = self;
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id resultObj)
     {
         NSData *data = (NSData *)resultObj;
         
         NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
         [tempSelf TaskCompleted:BJ_ERROR_SUCCESSFULL result:data];
     
     }failure:^(AFHTTPRequestOperation *op, NSError *error)
     {
         [tempSelf TaskCompleted:BJ_ERROR_REQUEST_FAIL result:nil];
     }];
    
    [operation start];
    
   //    __weak typeof(self) tempSelf = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//        sleep(3);
//        NSLog(@"*************DOTask Background ********************");
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [tempSelf TaskCompleted:0];
//        });
//    });
    return 3;
}

@end
