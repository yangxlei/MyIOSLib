//
//  SelectImageTools.m
//  BJDataProject
//
//  Created by YangXIAOYU on 14/10/27.
//  Copyright (c) 2014年 YangXIAOYU. All rights reserved.
//

#import "SelectImageTools.h"
#import "UIActionSheet+Blocks.h"
#import "ConfirmImageController.h"

@interface SelectImageTools ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ConfirmImageControllerDelegate>

@property (nonatomic, assign) int picNum;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* album;
@property (nonatomic, strong) NSString* takePicture;
@property (nonatomic, assign) bool frontCamera;
@property (nonatomic, strong) id<NSObject> params;
@property (nonatomic, assign) UIViewController *viewController;
@property (nonatomic, copy) finishCallback callback;
@property (nonatomic, assign) BOOL allowEditing;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
- (void)show;
@end

@implementation SelectImageTools

+ (instancetype)shareSelectImageTools
{
    static SelectImageTools *tools = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tools = [[SelectImageTools alloc] init];
    });
    return tools;
}

- (void)selectImagesBeginWith:(id)controller
              andAllowEditing:(BOOL)allowEditing
                    andPicNum:(int)picNum
                   andOptions:(NSDictionary *)options
               andFrontCamera:(BOOL)frontCamera
            andFinishCallback:(finishCallback)callback
                    andParams:(id)params{
    self.picNum = picNum;
    self.allowEditing = allowEditing;
    if (options) {
        self.title = options[ActionTitle];
        self.album = options[AlbumTitle];
        self.takePicture = options[TakePictureTitle];
    }else
    {
        self.title = @"选择图片来源";
        self.album = @"相册";
        self.takePicture = @"拍照";
    }
    self.frontCamera = frontCamera;
    self.callback = callback;
    self.params = params;
    self.viewController = controller;
    self.imagePicker.allowsEditing = self.allowEditing;
    [self show];
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (void)show
{
    [UIActionSheet showInView:self.viewController.view withTitle:self.title cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[self.album,self.takePicture] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
            {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.viewController presentViewController:self.imagePicker animated:YES completion:^{
                    
                }];
            }
                break;
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    //_imagePicker.showsCameraControls = NO;
                    if (self.frontCamera) {
                        BOOL isRearSupport = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                        if (isRearSupport) {
                            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                        }else
                        {
                            UIAlertView *show = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持前置摄像头" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                            [show show];
                        }
                    }
                    [self.viewController presentViewController:self.imagePicker animated:YES completion:^{
                        
                    }];
                }else
                {
                    UIAlertView *show = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持摄像头" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [show show];
                }
            }
                break;
        }
    }];
}

- (void)dealloc
{
    
}

#pragma mark -- UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info = %@",info);
    if (picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary&&!self.allowEditing) {
        ConfirmImageController *vc = [[ConfirmImageController alloc] init];
        vc.delegate = self;
        [picker presentViewController:vc animated:YES completion:^{
            vc.contentView.image = info[@"UIImagePickerControllerOriginalImage"];
        }];
        return;
        
    }
    if (info[@"UIImagePickerControllerOriginalImage"]) {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        if (self.callback) {
            self.callback(image, self.params);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
}

#pragma mark -- ConfirmImageControllerDelegate
- (void)confirmSelectImage:(ConfirmImageController *)con andImage:(UIImage *)image{
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (self.callback) {
        self.callback(image, self.params);
    }
}
@end
