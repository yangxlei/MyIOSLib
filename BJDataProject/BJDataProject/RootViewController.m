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

@interface RootViewController ()<BJDataDelegate>
{
    BJUserAccount *_account;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 50, 100, 50);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _account = [[BJUserAccount alloc] initWithDomain:USER_DOMAIN_MAIN];
    [_account addDelegate:self];
    
}

- (void)buttonAction:(id)sender
{
//    SecondViewController *second = [[SecondViewController alloc] init];
//    [self.navigationController pushViewController:second animated:YES];
    
    [_account loginWithPerson:11 token:@"auth_token"];
//    [_account logout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataEvent:(BJData *)_data error:(int)_error ope:(int)_ope error_message:(NSString *)_error_message params:(id)params
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
