//
//  ConfirmImageControllerViewController.m
//  BJDataProject
//
//  Created by YangXIAOYU on 14/10/29.
//  Copyright (c) 2014年 YangXIAOYU. All rights reserved.
//

#import "ConfirmImageController.h"

@interface ConfirmImageController ()

@end

@implementation ConfirmImageController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if(self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.contentMode = UIViewContentModeScaleAspectFit;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)confirmAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(confirmSelectImage:andImage:)]) {
            [self.delegate confirmSelectImage:self andImage:self.contentView.image];
        }
    }];
}
@end
