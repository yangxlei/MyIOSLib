//
//  BJDataFactory.m
//  BJDataProject
//
//  Created by 杨磊 on 14-10-29.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "BJDataFactory.h"
#import "Common.h"

@interface BJDataLinkList : NSObject
@property (nonatomic, strong) BJDataLinkList *next;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, weak) BJData *data;

@end

@implementation BJDataLinkList
@end

@interface BJDataFactory()
{
    BJDataLinkList *_linkList;
}

@end

@implementation BJDataFactory

+ (instancetype)shareInstance
{
    static BJDataFactory *factory = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        factory = [[self alloc] init];
    });
    return factory;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _linkList = [[BJDataLinkList alloc] init];
    }
    return self;
}

- (BJUserAccount *)chooseUserAccount
{
    BJUserAccount *account = CommonInstance.mainAccount;
    if (account == nil)
    {
        account = CommonInstance.anonymousAccount;
    }
    return account;
}

- (void)addBJDataIntoLink:(BJData *)data
{
    if ([data isKindOfClass:[BJUserAccount class]])
        return;
    BJDataLinkList *item = _linkList;
    while (item.next != nil) {
        item = item.next;
    }
    
    BJDataLinkList *next_item = [[BJDataLinkList alloc] init];
    next_item.data = data;
    next_item.type = [data getType];
    item.next = next_item;
}

- (void)removeBJDataFromLink:(BJData *)data
{
    BJDataLinkList *item = _linkList;
    while (item.next != nil) {
        BJDataLinkList *next = item.next;
        if (next.data == nil)
        {
            item.next = next.next;
            next.next = nil;
            next = nil;
        }
        else
        {
            item = next;
        }
//        NSLog(@"data = %@  type = %@", next.data, next.type);
//        if (next.data == data)
//        {
//            item.next = next.next;
//            next.data = nil;
//            next.next = nil;
//            next = nil;
//            break;
//        }
//        else
//        {
//            item = next;
//        }
    }
}

- (BJData *)findBJDataWithType:(NSString *)dataType
{
    BJDataLinkList *item = _linkList;
    while (item.next != nil) {
        BJDataLinkList *next = item.next;
        NSLog(@"Data %@", next.data);
        if ([dataType isEqualToString:[next.data getType]])
        {
            return next.data;
        }
        item = next;
    }

    return nil;
}

- (void)boardCastMessage:(NSString *)dataType
                 message:(NSString *)message
                  params:(id)params
{
    BJDataLinkList *item = _linkList;
    while (item.next != nil) {
        BJDataLinkList *next = item.next;
        
        if (dataType == nil || [dataType isEqualToString:[next.data getType]])
        {
            BOOL intercept = [next.data messageHandle:message params:params];
            if (intercept)
            {
                break;
            }
        }
        item = next;
    }
}

@end
