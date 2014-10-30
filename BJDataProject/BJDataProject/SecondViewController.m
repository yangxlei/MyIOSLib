//
//  SecondViewController.m
//  BJDataProject
//
//  Created by 杨磊 on 14-9-17.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "SecondViewController.h"
#import "BJSimpleData.h"
#import "TaskQueue.h"
#import "TestTaskItem.h"
#import "TestTaskItem2.h"
#import "BJDataFactory.h"
#import "CaseList.h"
#import "SubjectData.h"

@interface SecondViewController ()<TaskQueueDelegate, TaskItemDelegate>
{
    BJData  *_data;
    TaskQueue *taskQueue;
    SubjectData *subjects;
}

@end

@implementation SecondViewController

- (void)taskWillStart:(TaskItem *)taskItem
{
    NSLog(@"taskWillStart  %@", NSStringFromClass([taskItem class]));
}

-(void)taskDidStart:(TaskItem *)taskItem
{

    NSLog(@"taskDidStart %@", NSStringFromClass([taskItem class]));
}

- (void)taskDidFinished:(TaskItem *)taskItem
{
    NSLog(@"taskDidFinished %@", NSStringFromClass([taskItem class]));
}

- (void)taskQueueFinished:(TaskQueue *)taskQueue param:(id)param error:(int)error
{
    NSLog(@"taskQueueFinished %@ , error %d", param, error);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"通知" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 50, 100, 50);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    subjects = [[SubjectData alloc] init];
}

- (void)buttonAction:(id)sender
{
    
    [[BJDataFactory shareInstance] boardCastMessage:@"CaseList" message:@"helloWorld" params:@"hahaah"];
//    [_data invokeDelegateWithError:ERROR_SUCCESSFULL ope:1 error_message:@"成功" params:nil];
//    
//    taskQueue = [[TaskQueue alloc] init];
//    TestTaskItem *item = [[TestTaskItem alloc] init];
//    item.delegate = self;
//    [taskQueue addTaskItem:item];
//    
//    TestTaskItem2 *item2 = [[TestTaskItem2 alloc] init];
//    item2.delegate = self;
//    [taskQueue addTaskItem:item2];
//    
//    taskQueue.delegate = self;
//    [taskQueue start:@"helloTask"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _data = [[BJData alloc] init];
//    _data = [[BJSimpleData alloc] init];
//    [_data addDelegate:self];
//    NSLog(@"type : %@", [_data getType]);
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [_data removeDelegate:self];
}

- (void)dataEvent:(BJData *)_data
            error:(int)_error
              ope:(int)_ope
    error_message:(NSString *)_error_message
           params:(id)params
{
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
