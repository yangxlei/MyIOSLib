//
//  ConfirmImageControllerViewController.h
//  BJDataProject
//
//  Created by YangXIAOYU on 14/10/29.
//  Copyright (c) 2014年 YangXIAOYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmImageControllerDelegate;
@interface ConfirmImageController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (assign, nonatomic) id<ConfirmImageControllerDelegate> delegate;
- (IBAction)cancelAction:(id)sender;

- (IBAction)confirmAction:(id)sender;
@end

@protocol ConfirmImageControllerDelegate <NSObject>

- (void)confirmSelectImage:(ConfirmImageController *)con andImage:(UIImage *)image;

@end