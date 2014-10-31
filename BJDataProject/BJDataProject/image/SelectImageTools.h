//
//  SelectImageTools.h
//  BJDataProject
//
//  Created by YangXIAOYU on 14/10/27.
//  Copyright (c) 2014年 YangXIAOYU. All rights reserved.
//

#import <UIKit/UIKit.h>

 NSString *const ActionTitle;
 NSString *const AlbumTitle;
 NSString *const TakePictureTitle;

typedef void(^finishCallback)(UIImage *image,id params);

@interface SelectImageTools : NSObject

+ (instancetype)shareSelectImageTools;

/**
 *  选择图片方法
 *
 *  @param controller   需要显示ActionSheet的controller
 *  @param allowEditing 是否需要裁减
 *  @param picNum       选择图片的个数
 *  @param options      ActionSheet的标题，可以是nil
 *  @param frontCamera  是否使用前置摄像头
 *  @param callback     回调
 *  @param params       一些其他的参数，可为nil
 */
- (void)selectImagesBeginWith:(id)controller
              andAllowEditing:(BOOL)allowEditing
                    andPicNum:(int)picNum
                   andOptions:(NSDictionary *)options
               andFrontCamera:(BOOL)frontCamera
            andFinishCallback:(finishCallback)callback
                    andParams:(id)params;
@end
