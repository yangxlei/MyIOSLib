//
//  SecondViewController.m
//  BJDataProject
//
//  Created by 杨磊 on 14-9-17.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import "SecondViewController.h"
#import "BJSimpleData.h"

@interface SecondViewController ()
{
    BJData  *_data;
}

@end

@implementation SecondViewController

- (void)dealloc
{
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
}

- (void)buttonAction:(id)sender
{
    [_data invokeDelegateWithError:ERROR_SUCCESSFULL ope:1 error_message:@"成功" params:nil];
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
    _data = [[BJSimpleData alloc] init];
    [_data addDelegate:self];
    NSLog(@"type : %@", [_data getType]);
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_data removeDelegate:self];
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
