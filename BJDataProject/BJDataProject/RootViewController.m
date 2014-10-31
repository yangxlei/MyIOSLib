//
//  RootViewController.m
//  BJDataProject
//
//  Created by 杨磊 on 14-9-17.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"
#import "BJUserAccount.h"
#import "TaskQueue.h"
#import "TestTaskItem.h"
#import "JsonUtils.h"
#import "APIManager.h"
#import "SelectImageTools.h"
#import "BJFileManager.h"
#import "TeacherDetailInfo.h"
#import "CaseList.h"
#import "SubjectData.h"
#include "MD5.h"

@interface RootViewController ()<BJDataDelegate, TaskItemDelegate, TaskQueueDelegate>
{
    BJUserAccount *_account;
    TaskQueue *taskQueue;
    
    TeacherDetailInfo *detailInfo;
    
    TaskQueue *tasks[10];
    
    CaseList *caseList;
    SubjectData *subjects;
}

@end

@implementation RootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)taskWillStart:(TaskItem *)taskItem
{
}

- (void)taskDidStart:(TaskItem *)taskItem
{
//    NSString *result =  self.text ;
}

- (void)taskDidFinished:(TaskItem *)taskItem
{
}

- (void)taskQueueFinished:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 50, 100, 50);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"跳转2" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 150, 100, 50);
    [button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    _account = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_MAIN];
//    [_account addDelegate:self];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"获取图片" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 250, 100, 50);
    [button addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectImage:(id)sender
{
    [[SelectImageTools shareSelectImageTools] selectImagesBeginWith:self andAllowEditing:YES andPicNum:1 andOptions:nil andFrontCamera:NO andFinishCallback:^(UIImage *image, id params) {
        
    } andParams:nil];
}

- (void)buttonAction2:(id)sender
{
    caseList = [[CaseList alloc] init];
    [caseList refresh];
    [caseList addDelegate:self];
    
    SecondViewController *second = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:second animated:YES];

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"18611579546",@"value", @"123456", @"password", nil];
    NSInteger taskId = [[APIManager shareInstance] requestAPIWithPost:@"/auth/teacherLogin>&value=1999&password=123456" postBody:nil  callback:^(HTTPRequest *request, HTTPResult *result) {
        NSDictionary *_result = [result.data dictionaryValueForKey:@"result"];
        NSLog(@"result : %@", _result);
        NSString *token = [_result stringValueForKey:@"auth_token" defaultValue:nil];
        NSDictionary *person = [_result dictionaryValueForKey:@"person"];
        [CommonInstance.mainAccount loginWithPerson:[person longLongValueForKey:@"id" defalutValue:0] token:token];
    }];
//    [caseList refresh];
//    subjects = [[SubjectData alloc] init];
//    [subjects addDelegate:self];
//    [subjects refresh];
    
}


- (void)buttonAction:(id)sender
{
    
//    caseList = [[CaseList alloc] init];
//    [caseList refresh];
//    [caseList addDelegate:self];
//    NSLog(@"%@", caseList.list);
    
//    detailInfo = [[TeacherDetailInfo alloc] init];
//    [detailInfo refresh];
//    [detailInfo addDelegate:self];
//    NSLog(@"cache = %@", detailInfo.data);
    
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"aa",@"bb", nil];
//    NSString *filepath = [BJFileManager getCacheFilePath:@"test_cache"];
//    [dic writeToFile:filepath atomically:YES];
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"18611579546",@"value", @"123456", @"password", nil];
//    NSInteger taskId = [[APIManager shareInstance] requestAPIWithPost:@"/teacher_center/detailInfo" postBody:param callback:^(HTTPRequest *request, HTTPResult *result) {
//        NSDictionary *_result = [result.data dictionaryValueForKey:@"result"];
//        NSLog(@"result : %@", _result);
//        NSString *token = [_result stringValueForKey:@"auth_token" defaultValue:nil];
//        NSDictionary *person = [_result dictionaryValueForKey:@"person"];
//        [CommonInstance.mainAccount loginWithPerson:[person longLongValueForKey:@"id" defalutValue:0] token:token];
//    }];
//
    
//    NSInteger taskId = [APIManagerInstance requestAPIWithGet:@"http://www.baidu.com" callback:^(HTTPRequest *request, HTTPResult *result) {
//    }];
//    [[APIManager shareInstance] cancelRequest:taskId];
//    NSString *api = @"/teacher_center/info?&name=xxx&age=22";
//    
//    NSMutableDictionary *postBody = [[NSMutableDictionary alloc] init];
//    NSString *url = nil;//[[APIManager shareInstance] signatureApiWithPost:api postBody:postBody account:[[Common shareInstance] getMainAccount]];
//    NSLog(@"%@\n%@", url, postBody);
    
//    NSString *str = @"{\"aaa\":\"bbb\", \"ccc\":1, \"list\":[{\"name\":\"yl\", \"age\":23}], \"result\":{\"ext\":\"hehe\"}}";
//    NSDictionary *dic = [str jsonValue];
//    [dic setIntValue:1 forKey:@"sex"];
//    [dic removeValueForKey:@"aaa"];
//    NSArray *list = [dic arrayValueForKey:@"list"];
////    [list addObject:[str jsonValue]];
//    [list removeObjectAt:0];
//    
//    NSDictionary *result = [dic dictionaryValueForKey:@"result"];
//    [result setDoubleValue:4.6 forKey:@"money"];
//    [result setValue:@"haha" forKey:@"ext"];
//    NSLog(@"%@", dic);
//    NSArray *list = [dic valueForKey:@"list"];
//    NSDictionary *item = [list objectAtIndex:0];
//    NSLog(@"age : %d", [item intValueForkey:@"age" default:0]);
//
//    SecondViewController *second = [[SecondViewController alloc] init];
//    [self.navigationController pushViewController:second animated:YES];
    
//    [_account loginWithPerson:11 token:@"auth_token"];
//    [_account logout];
    
//    taskQueue = [[TaskQueue alloc] init];
//    TestTaskItem *item = [[TestTaskItem alloc] init];
//    item.delegate = self;
//    
//    [taskQueue addTaskItem:item];
//    taskQueue.delegate = self;
//    [taskQueue start:@"helloTask"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataEvent:(BJData *)_data error:(int)_error ope:(int)_ope error_message:(NSString *)_error_message params:(id)params
{
    NSLog(@"_data %@", _data);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
