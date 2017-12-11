//
//  PopViewController.m
//  WMS
//
//  Created by wandou on 2017/8/30.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "PopViewController.h"
#import "MJRefresh.h"

@interface PopViewController ()

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.dataArr = [NSMutableArray arrayWithObjects:@"上海益嘉物流有限公司",@"四川五粮液有限公司",@"京东物流有限公司",@"上海益嘉物流有限公司",@"四川五粮液有限公司",@"京东物流有限公司",@"上海益嘉物流有限公司",@"四川五粮液有限公司",@"京东物流有限公司",@"上海益嘉物流有限公司",@"四川五粮液有限公司",@"京东物流有限公司",@"上海益嘉物流有限公司",@"四川五粮液有限公司",@"京东物流有限公司", nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetMoreData:) name:@"DidGetMoreData" object:nil];
//    if ([self.curType isEqualToString:@"WarehouseManageSelectShipper"] || [self.curType isEqualToString:@"WarehouseManageSelectMaterial"]) {
//        [self setMJRefreshUI];
//    }
    
    self.dataArr = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.curType isEqualToString:@"WarehouseManageSelectShipper"] || [self.curType isEqualToString:@"WarehouseManageSelectMaterial"]) {
        [self setMJRefreshUI];
    }
}
- (void)setMJRefreshUI{
    __weak __typeof(self) weakSelf = self;
    
    /*
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    */
    
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)loadNewData
{
    
}

- (void)loadMoreData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMoreData" object:_curType];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ================= 监听方法 =================
- (void)didGetMoreData:(NSNotification *)notify
{
    if ([[notify object] isEqualToString:@"NoMoreData"]){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popCell" forIndexPath:indexPath];
    static NSString *cellIdenfier = @"cellIdenfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenfier];
    }
    
    // Configure the cell...
//    NSString *title = [self.dataArr objectAtIndex:indexPath.row];
//    cell.textLabel.text = title;
    if (self.dataArr.count > indexPath.row) {
        NSDictionary *dict = [self.dataArr objectAtIndex:indexPath.row];
        NSString *title;
        NSString *detail;
        /*
         NSString *title = [dict objectForKey:@"name"];
         if (title == nil) {
         title = [dict objectForKey:@"rrName"];
         }*/
        
        if ([_curType isEqualToString:@"WarehouseManageSelectRegion"]) {
            title = [dict objectForKey:@"rrName"];
        }else if([_curType isEqualToString:@"WarehouseManageSelectStatus"]){
            title = [dict objectForKey:@"des"];
            detail = [dict objectForKey:@""];
        }else if([_curType isEqualToString:@"WarehouseManageSelectAssistant"]){
            title = [dict objectForKey:@"assistanceName"];
        }else if([_curType isEqualToString:@"WarehouseManageSelectShipper"]|| [_curType isEqualToString:@"WarehouseManageSelectMaterial"]){
            title = [dict objectForKey:@"name"];
            detail = [dict objectForKey:@"code"];
            cell.detailTextLabel.text = detail;
        }
        else{
            title = [dict objectForKey:@"name"];
        }
        
        //title = [NSString stringWithFormat:@"%ld %@",indexPath.row,title];
        cell.textLabel.text = title;
    }
    
    return cell;
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([_curType isEqualToString:@"WarehouseManageSelectShipper"]|| [_curType isEqualToString:@"WarehouseManageSelectMaterial"]){
//        return 60;
//    }else{
//        return 44;
//    }
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [self.dataArr objectAtIndex:indexPath.row];
    /*
    NSString *title = [dict objectForKey:@"name"];
    if (title == nil) {
        title = [dict objectForKey:@"rrName"];
    }*/
    NSString *title;
    if ([_curType isEqualToString:@"WarehouseManageSelectRegion"]) {
        title = [dict objectForKey:@"rrName"];
    }else if([_curType isEqualToString:@"WarehouseManageSelectStatus"]){
        title = [dict objectForKey:@"des"];
    }else if([_curType isEqualToString:@"WarehouseManageSelectAssistant"]){
        title = [dict objectForKey:@"assistanceName"];
    }else{
        title = [dict objectForKey:@"name"];
    }
    WMSSelect *selectModel = [[WMSSelect alloc] init];
    selectModel.title = title;
    selectModel.index = indexPath.row;
    
    self.block(selectModel);
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
