//
//  BJListDataViewController.m
//  BJDataProject
//
//  Created by Randy on 14/10/29.
//  Copyright (c) 2014年 bjhl. All rights reserved.
//

#import "BJListDataViewController.h"

@interface BJListDataViewController ()

@end

@implementation BJListDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (! _tableView) {
        CGRect rect = self.view.frame;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dataEvent:(BJData *)_data
            error:(int)_error
              ope:(int)_ope
    error_message:(NSString *)_error_message
           params:(id)params
{

}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    int numberofItems = self.listData.list.count;
    if (row == numberofItems)
    {
//        [self.listData getMore];
    }
    else if (row < numberofItems)
    {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 默认的格子大小
    int height = 52.0;//更多的高度
    int row = [indexPath row];
    
    int numberofItems = self.listData.list.count;
    
    BJDATA_STATUS_CODE ds = self.listData.status;
    
    if (ds == STATUS_NO_CONNECT_AND_NO_DATA)
    {//在数据为空，并且没有下载正在执行的时候，那么这个tableView是0行。这种状态只存在于当前页面不是显示页面的时候
        //            BJASSERT(0);
    }
    else if (ds == STATUS_NETWORK_ERROR_AND_NO_DATA)
    {//这种情况是数据源真的是没有数据，或者因为网络错误，没有取下来数据
        return tableView.frame.size.height;
    }
    else if (ds == STATUS_EMPTY)
    {
        return tableView.frame.size.height;
    }
    return  0;
}


@end
