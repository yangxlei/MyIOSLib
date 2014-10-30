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
@end
