//
//  BJListDataViewController.h
//  BJDataProject
//
//  Created by Randy on 14/10/29.
//  Copyright (c) 2014年 Randy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJListData.h"
#import "BJDataDelegate.h"
@interface BJListDataViewController : UIViewController<BJDataDelegate,
    UITableViewDataSource,
    UITableViewDelegate>
@property (strong, nonatomic, readonly)BJListData *listData;
@property (strong, nonatomic)IBOutlet UITableView *tableView;

/**
 *  子类重载以下方法，控制对应的特性
 *
 */
- (UITableViewCellSelectionStyle)cellSelectionStyle;
- (NSString *)listDataClassName;
- (void)removeLoadingView;
- (void)showLoadingView:(BJDATA_OPERATION_CODE)oper;

/**
 *  先setInfos在加载此视图
 *
 *  @param dic 配置信息
 */
-(void)setInfos:(NSDictionary*)dic;
@end
