//
//  BJListDataViewController.m
//  BJDataProject
//
//  Created by Randy on 14/10/29.
//  Copyright (c) 2014年 bjhl. All rights reserved.
//

#import "BJListDataViewController.h"
#import "ErrorCell.h"
#import "NoDataCell.h"
#import "nibLoader.h"
#import "BJListDataCell.h"
#import "MJRefresh.h"
#import "BJCodeDefine.h"

#import "objc/runtime.h"
#import "objc/message.h"

#import "BJDataProtocol.h"

#import "DictionaryExtending.h"

#import "ListDataDefine.h"

@interface BJListDataViewController ()
{
    SEL model2UI;
    
}

@property (strong, nonatomic)ErrorCell *networkErrorTableViewCell;//因为网络错误，没有取下来数据，也没有cache的时候显示。
@property (strong, nonatomic)NoDataCell *noDataTableViewCell;//数据下载完了，这个人他就是没有动态
@property (assign, nonatomic)BOOL no_push_refresh;
@property (assign, nonatomic)BOOL has_error_cell;
@property (assign, nonatomic)BOOL loading_tip;
@property (assign, nonatomic)BOOL get_more;
@property (assign, nonatomic)BOOL isEdit;
@property (assign, nonatomic)CGFloat specialview_height;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *classCell;
@property (strong, nonatomic)NSString *selectedClass;
@property (strong, nonatomic)NSString *selectedTitle;

@property (strong, nonatomic)NSDictionary *infoDic;

@end

@implementation BJListDataViewController
@synthesize listData = _listData;
- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    [self.listData removeDelegate:self];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.listData addDelegate:self];
    if (!self.no_push_refresh) {
        [self.tableView headerBeginRefreshing];
    }
    
    if ([self.listData isOperation:OPERATION_GET_MORE] &&
        self.get_more) {
        [self.tableView footerBeginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.listData removeDelegate:self];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (! _tableView) {
        CGRect rect = self.view.frame;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.autoresizingMask = UIViewAutoresizingNone |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleBottomMargin;
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

-(void)setInfos:(NSDictionary*)dic
{
    self.infoDic = dic;
    //计算tableview内容区域可以显示多少个像素?
    float content_height = 0;
    if (self.tableView)
    {
        content_height = self.tableView.contentInset.top;
        if (self.tableView.tableHeaderView)
        {
            content_height += self.tableView.tableHeaderView.frame.size.height;
        }
        content_height += self.tableView.sectionHeaderHeight;
        content_height = self.tableView.frame.size.height - content_height;
    }
    self.specialview_height = content_height;
    if (self.specialview_height < 50) self.specialview_height = 50;
    
    self.name = dic[@"name"];
    if (self.name == nil) {
        self.name = @"";
    }

    NSString* get_more = [dic valueForKey:@"get_more"];
    if (get_more == nil)
    {
        get_more = @"查看更多%@";
    }
    model2UI = sel_registerName([[dic valueForKey:@"model2UI"] UTF8String]);
    self.classCell = [dic valueForKey:@"class_cell"];
    self.no_push_refresh = [dic[@"no_push_refresh"] boolValue];
    self.has_error_cell = [dic[@"has_error_cell"] boolValue];
    self.get_more = [dic[@"get_more"] boolValue];
    self.isEdit = [dic[@"is_edit"] boolValue];
    self.selectedClass = dic[@"selected_class"];
    self.selectedTitle = dic[@"selected_title"];
    
    __weak BJListDataViewController *theModel = self;
    if (!self.no_push_refresh)
    {
        [self.tableView addHeaderWithCallback:^{
            [theModel refresh];
        }];
    }
    
    if (self.get_more) {
        [self.tableView addFooterWithCallback:^{
            [theModel getMoreDataList];
        }];
        [self.tableView setFooterRefreshingText:[NSString stringWithFormat:get_more, self.name]];
        [self.tableView setFooterHidden:!(self.get_more && [self.listData hasMore])];
    }
    
    if (self.has_error_cell)
    {
        NSString* xib = [dic valueForKey:@"nodata_xib"];
        if (xib == nil)
        {
            xib = @"NoDataCell";
            self.noDataTableViewCell = [nibLoader load:xib params:nil];
        }
        if (!self.noDataTableViewCell) {
            self.noDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:xib owner:nil options:nil] objectAtIndex:0];//
        }
        
        xib = [dic valueForKey:@"error_xib"]; if (xib == nil) xib = @"ErrorCell";
        self.networkErrorTableViewCell = [nibLoader load:xib params:nil];
    }
    
    [self.noDataTableViewCell setNodataText:[NSString stringWithFormat:[dic valueForKey:@"empty_data"], self.name]];
}

#pragma mark - 方法
- (NSString *)listDataClassName
{
    return @"BJListData";
}

- (BJListData *)listData
{
    if (!_listData) {
        _listData = [[NSClassFromString([self listDataClassName]) alloc] init];
    }
    return _listData;
}

- (void)getMoreDataList
{
    if (![self.listData isOperation:OPERATION_GET_MORE] && self.get_more) {
        [self.listData getMore];
        [self showLoadingView:OPERATION_GET_MORE];
    }
}

- (void)refresh
{
    if (![self.listData isOperation:OPERATION_REFRESH]) {
        [self.listData refresh];
        [self showLoadingView:OPERATION_REMOVE_ITEM];
    }
}

- (void)removeLoadingView
{
    
}

- (void)showLoadingView:(BJDATA_OPERATION_CODE)oper
{
    
}

#pragma mark - ListData请求回调
- (void)dataEvent:(BJData *)_data
            error:(int)_error
              ope:(int)_ope
    error_message:(NSString *)_error_message
           params:(id)params
{
    if (_ope == OPERATION_REFRESH) {
        [self.tableView headerEndRefreshing];

    }
    else if (_ope == OPERATION_GET_MORE)
    {
        [self.tableView footerEndRefreshing];
        [self.tableView setFooterHidden:!(self.get_more && [self.listData hasMore])];
    }
    else if (_ope == OPERATION_REMOVE_ITEM)
    {
        [self removeLoadingView];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(self.listData.status == STATUS_NO_CONNECT_AND_NO_DATA)
    {
        return 0;
    }
    return 1;
}

- (NSUInteger)getRowNumber
{
    return self.listData.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BJDATA_STATUS_CODE ds = self.listData.status;
    if (ds == STATUS_EMPTY)
    {//空数据
        return self.has_error_cell? 1 : 0;
    }
    else if (ds == STATUS_NO_CONNECT_AND_NO_DATA)
    {//在数据为空，并且没有下载正在执行的时候，那么这个tableView是0行。这种状态只存在于当前页面不是显示页面的时候
        return 0;
    }
    else if (ds == STATUS_NETWORK_ERROR_AND_NO_DATA)
    {
        return self.has_error_cell? 1 : 0;
    }
    
    // 获取当前使用数据的长度返回
    NSUInteger row = [self getRowNumber];
    return row;
}

- (UITableViewCellSelectionStyle)cellSelectionStyle
{
    if (self.selectedClass) {
        return UITableViewCellSelectionStyleGray;
    }
    else
        return UITableViewCellSelectionStyleNone;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberofItems = [self getRowNumber];
    
    BJDATA_STATUS_CODE ds = self.listData.status;
    
    if (ds == STATUS_NO_CONNECT_AND_NO_DATA && numberofItems == 0)
    {//在数据为空，并且没有下载正在执行的时候，那么这个tableView是0行。这种状态只存在于当前页面不是显示页面的时候
//        BJASSERT(0);
    }
    else if (ds == STATUS_NETWORK_ERROR_AND_NO_DATA && numberofItems == 0)
    {//这种情况是数据源真的是没有数据，或者因为网络错误，没有取下来数据
        return self.networkErrorTableViewCell;
    }
    else if (ds == STATUS_EMPTY && numberofItems == 0)
    {
        return self.noDataTableViewCell;
    }
    
    NSString *CellIdentifier = NSStringFromClass([self class]);
    
    BJListDataCell *cell = (BJListDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        Class clazz = NSClassFromString(self.classCell);
        cell = [[clazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (![cell isKindOfClass:[BJListDataCell class]]) {
            NSAssert1(0, @"%s,cell必须是BJListDataCell得子类", __FUNCTION__);
        }
    }
    
    NSDictionary *item = self.listData.list[indexPath.row];
    NSDictionary* univiewinfo =  objc_msgSend([NSDictionary class], model2UI, item, (int)tableView.frame.size.width, indexPath, NO);
    cell.selectionStyle = [self cellSelectionStyle];
    
    [cell setCellInfo:univiewinfo];
    
    return cell;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    NSInteger numberofItems = self.listData.list.count;
    if (row < numberofItems)
    {
        if (self.selectedClass) {
            UIViewController<BJDataProtocol> *viewController = [[NSClassFromString(self.selectedClass) alloc] init];
            if ([viewController conformsToProtocol:@protocol(BJDataProtocol)]) {
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
                if (self.selectedTitle.length>0) {
                    [dataDic setObject:self.selectedTitle forKey:LIST_DATA_SELECTED_TITLE];
                }
                [dataDic setObject:indexPath forKey:LIST_DATA_SELECTED_INDEXPATH];
                [dataDic setObject:self.listData forKey:LIST_DATA_SELECTED_LIST_DATA];
                viewController.data = dataDic;
                if (viewController) {
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                else
                    NSAssert1(0, @"%s, NSClassFromString 字符串不是正确的类名", __FUNCTION__);
            }
            else
                NSAssert1(0, @"%s ,selectedClass必须遵循BJDataProtocol的协议", __FUNCTION__);
        }
    }
    else
    {

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BJDATA_STATUS_CODE ds = self.listData.status;
    
    if (ds == STATUS_NO_CONNECT_AND_NO_DATA)
    {//在数据为空，并且没有下载正在执行的时候，那么这个tableView是0行。这种状态只存在于当前页面不是显示页面的时候
        return 0;
    }
    else if (ds == STATUS_NETWORK_ERROR_AND_NO_DATA)
    {//这种情况是数据源真的是没有数据，或者因为网络错误，没有取下来数据
        return self.specialview_height;
    }
    else if (ds == STATUS_EMPTY)
    {
        return self.specialview_height;
    }
    
    NSDictionary *item = self.listData.list[indexPath.row];
    NSDictionary* univiewinfo =  objc_msgSend([NSDictionary class], model2UI, item, (int)tableView.frame.size.width, indexPath, YES);
    
    CGSize si = [univiewinfo sizeValueForKey:LIST_DATA_CELL_SIZE];
    return  si.height;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)_tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        return  UITableViewCellEditingStyleDelete;
    }
    else
        return  UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        if ([self.listData removeItem:indexPath.row])
            [self showLoadingView:OPERATION_REMOVE_ITEM];
    }
}


@end
