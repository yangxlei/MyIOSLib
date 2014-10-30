//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___FILEBASENAME___.h"
#import "APITask.h"

#define GET_DATA_API @"/user/info"

@implementation ___FILEBASENAMEASIDENTIFIER___

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        [self loadCache];
    }
    return self;
}

- (void)doRefreshOperation:(TaskQueue *)taskQueue
{
    APITask *task = [[APITask alloc] initWithAPI:GET_DATA_API postBody:nil];
    [taskQueue addTaskItem:task];
}

- (NSString *)getCacheKey
{
    return NSStringFromClass([self class]);
}

@end
