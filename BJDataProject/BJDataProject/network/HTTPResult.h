//
//  HTTPResult.h
//  BJDataProject
//
//  Created by Randy on 14/10/25.
//  Copyright (c) 2014年 Randy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTTPRequest;
@interface HTTPResult : NSObject
@property (assign, readonly, nonatomic)NSUInteger taskID;
@property (strong, readonly, nonatomic)NSString *url;
@property (strong, readonly, nonatomic)id data;
@property (assign, readonly, nonatomic)NSInteger code;//返回code
@property (strong, readonly, nonatomic)NSString *reason;
@property (strong, readonly ,nonatomic)NSDictionary *parameters;

- (instancetype)initWithResult:(HTTPRequest *)request
                      response:(id)responseObject
                         error:(NSError *)error;

@end
