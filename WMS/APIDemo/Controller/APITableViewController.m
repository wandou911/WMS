//
//  APITableViewController.m
//  WMS
//
//  Created by wandou on 08/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import "APITableViewController.h"
#import "WMSUser.h"

@interface APITableViewController ()

@end

@implementation APITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.titleArray = [NSMutableArray arrayWithObjects:@"获取库区及下属库区信息",@"获取库位信息",@"分页获取物流中心下货主",@"分页物料查询",
                       @"获取库位下的托盘",@"创建无单转储",@"获取转储推荐库位列表",@"批量无单转储",@"无单转储删除",
                       @"判断是否可转储",@"转储单处理",@"获取物料状态",@"获取辅助叉车",@"",
                       @"",@"",@"",@"",@"",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.titleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"APIIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self getWarehouseRegion];//1 获取仓库及下属库区信息
            break;
        case 1:
            [self getSlInfo];//2 获取库位信息
            break;
        case 2:
            [self getCustomer];//3 分页获取物流中心下货主
            break;
        case 3:
            [self getMaterial];//4 分页物料查询
            break;
        case 4:
            [self getTrayBySlId];//5 获取库位下的托盘
            break;
        case 5:
            [self createNoOrderTransfer];//6 创建无单转储
            break;
        case 6:
            [self getTransCommandLocation];//7 获取推荐库位列表
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            [self judgeTrayTransfer];//10 判断是否可转储
            break;
        case 10:
            [self submitTransOperate];//11 转储单处理
            break;
        case 11:
            [self getMaterialStatus];//12 获取物料状态枚举getAssistanceName
            break;
        case 12:
            [self getAssistanceName];//13 获取辅助叉车
            break;
        default:
            break;
    }
}

#pragma mark ================= 0 获取数据模板 =================

-(void)getDataSample
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",nil];
    [HttpTask getWarehouseRegion:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        NSDictionary *userInfo = [dictionary objectForKey:@"data"];
        
        
        if (status == 1) {
            
            
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
        }
    } failBlock:^(NSDictionary *errDict) {
        
    }];
    
}

#pragma mark ================= 1 获取仓库及下属库区信息 =================
-(void) getWarehouseRegion
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",nil];
    [HttpTask getWarehouseRegion:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}


#pragma mark ================= 2 获取库位信息 =================
-(void) getSlInfo
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"191";//仓库id
    NSString *rrId = @"";//库区id
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",rrId,@"rrId",nil];
    [HttpTask getSlInfo:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 3 分页获取物流中心下货主 =================
-(void) getCustomer
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *pageSize = @"20";//分页大小
    NSString *pageNo = @"3";//页码
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",pageSize,@"pageSize",pageNo,@"pageNo",nil];
    [HttpTask getCustomer:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}
#pragma mark ================= 4 分页物料查询 =================
-(void) getMaterial
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *barCode = @"";//条码
    NSString *pageSize = @"2530";//分页大小
    NSString *pageNo = @"2";//页码
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",barCode,@"barCode",pageSize,@"pageSize",pageNo,@"pageNo",nil];
    [HttpTask getMaterial:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}


#pragma mark ================= 5 获取库位下的托盘 =================
-(void) getTrayBySlId
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *slId = @"30132";//库位id
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",slId,@"slId",nil];
    DLog(@"param:%@",param);
    [HttpTask getTrayBySlId:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}


#pragma mark ================= 6 创建无单转储 =================
-(void) createNoOrderTransfer
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *updater = [[WMSUser sharedUser] userName];//操作人
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",updater,@"updater",nil];
    DLog(@"param:%@",param);
    [HttpTask createNoOrderTransfer:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 7 获取转储推荐库位列表 =================
-(void) getTransCommandLocation
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *rrId = @"431";//库区id
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",rrId,@"rrId",nil];
    DLog(@"param:%@",param);
    [HttpTask getTransCommandLocation:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}
#pragma mark ================= 8 批量无单转储 =================
-(void) batchTransNoOrder
{
    NSArray *trayCodes = @[@"123",@"456"];//转储的托盘号
    NSString *orderId = @"431";//单据号
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *fromSlId = @"192";//转储库位id
    NSString *toSlId = @"192";//转入库位id
    NSString *operater = [[WMSUser sharedUser] userName];//操作人
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:trayCodes, @"trayCodes",orderId, @"orderId",lcCode, @"lcCode",whId,@"whId",fromSlId,@"fromSlId",@"lcCode",toSlId,@"toSlId",operater,@"operater",nil];
    DLog(@"param:%@",param);
    [HttpTask batchTransNoOrder:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 9 无单转储删除 =================
-(void) deleteTransOrder
{
    NSString *orderId = @"431";//单据号
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *updater = [[WMSUser sharedUser] userName];//操作人
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:orderId, @"orderId",lcCode, @"lcCode",whId,@"whId",updater,@"updater",nil];
    DLog(@"param:%@",param);
    [HttpTask deleteTransOrder:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 10 判断是否可转储 =================
-(void) judgeTrayTransfer
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *orderItemId = @"ZCG04620171115000011";//明细号
    
    NSString *trayCode = @"G04620170919000000008";//托盘码
    //NSString *boxCode = @"G046HYSP-6937689902636";//箱码
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",orderItemId,@"orderItemId",trayCode, @"trayCode",nil];
    DLog(@"param:%@",param);
    [HttpTask judgeTrayTransfer:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}


#pragma mark ================= 11 转储单处理 =================
-(void) submitTransOperate
{
    NSString *orderId = @"G04620171104000000054";//明细号
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *updater = [[WMSUser sharedUser] userName];//箱码
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",orderId,@"orderId",updater, @"updater",nil];
    DLog(@"param:%@",param);
    [HttpTask submitTransOperate:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 12 获取物料状态枚举 =================
-(void) getMaterialStatus
{
    
    [HttpTask materialStatus:nil sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 13 获取辅助叉车 =================
-(void) getAssistanceName
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",nil];
    DLog(@"param:%@",param);
    [HttpTask getAssistanceName:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}


@end
