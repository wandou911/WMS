//
//  TransferStorageController.m
//  WMS
//
//  Created by wandou on 2017/9/6.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "TransferStorageController.h"
#import "TimeCollectionViewCell.h"
#import "WMSStorageLocation.h"

@interface TransferStorageController ()

@end

@implementation TransferStorageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"目标库位";
    //这个是数据源
    if (!_alltimeArray) {
        _alltimeArray = [[NSArray alloc]init];
        _alltimeArray = @[@"A001",@"A002",@"A003",@"A004",@"A005",@"A006",@"A007",@"A008",@"A009",@"A010",@"A011",@"A012",@"A013",@"A014",@"A015",@"A016",@"B001",@"B002",@"B003",@"B004",@"B005",@"B006",@"B007",@"B008",@"B009",@"B010",@"B011",@"B012",@"B013",@"B014",@"B015",@"B016",@"C001",@"C002",@"C003",@"C004",@"C005",@"C006",@"C007",@"C008",@"C009",@"C010",@"C011",@"C012",@"C013",@"C014",@"C015",@"C016",@"D001",@"D002",@"D003",@"D004",@"D005",@"D006",@"D007",@"D008",@"D009",@"D010",@"D011",@"D012",@"D013",@"D014",@"D015",@"D016",@"E001",@"E002",@"E003",@"E004",@"E005",@"E006",@"E007",@"E008",@"E009",@"E010",@"E011",@"E012",@"E013",@"E014",@"E015",@"E016",@"F001",@"F002",@"F003",@"F004",@"F005",@"F006",@"F007",@"F008",@"F009",@"F010",@"F011",@"F012",@"F013",@"F014",@"F015",@"F016",@"G001",@"G002",@"G003",@"G004",@"G005",@"G006",@"G007",@"G008",@"G009",@"G010",@"G011",@"G012",@"G013",@"G014",@"G015",@"G016",@"H001",@"H002",@"H003",@"H004",@"H005",@"H006",@"H007",@"H008",@"H009",@"H010",@"H011",@"H012",@"H013",@"H014",@"H015",@"H016",@"I001",@"I002",@"I003",@"I004",@"I005",@"I006",@"I007",@"I008",@"I009",@"I010",@"I011",@"I012",@"I013",@"I014",@"I015",@"I016",@"J001",@"J002",@"J003",@"J004",@"J005",@"J006",@"J007",@"J008",@"J009",@"J010",@"J011",@"J012",@"J013",@"J014",@"J015",@"J016",@"K001",@"K002",@"K003",@"K004",@"K005",@"K006",@"K007",@"K008",@"K009",@"K010",@"K011",@"K012",@"K013",@"K014",@"K015",@"K016",@"L001",@"L002",@"L003",@"L004",@"L005",@"L006",@"L007",@"L008",@"L009",@"L010",@"L011",@"L012",@"L013",@"L014",@"L015",@"L016",@"L001",@"L002",@"L003",@"L004",@"L005",@"L006",@"L007",@"L008",@"L009",@"L010",@"L011",@"L012",@"L013",@"L014",@"L015",@"L016"];
        
    }
    
    [_storageCollectionView registerClass:[TimeCollectionViewCell class] forCellWithReuseIdentifier:@"transferStorageCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createNoOrderTransfer];
    [self getCommendLocation];
}
#pragma mark ================= 自定义方法 =================

- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextStep:(id)sender {
    
    /*
     TransferViewController *detailControllrer =
     [[TransferViewController alloc] init];
     UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
     
     detailControllrer = [board instantiateViewControllerWithIdentifier: @"NavTransferViewController"];
     
     //[detailControllrer setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];UIModalPresentationOverFullScreen
     //[detailControllrer setModalPresentationStyle:UIModalPresentationFormSheet];
     [detailControllrer setModalPresentationStyle:UIModalPresentationPageSheet];
     [self presentModalViewController:detailControllrer animated:YES];
     */
    
    [self clickButton:sender];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFER_SUCCESS object:nil];
}

#pragma mark ================= 获取推荐库位信息 =================
- (void)getCommendLocation{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = self.transParam.selectWhid;//仓库id
    NSString *shipperCode = self.transParam.shipperCode;//货主代码
    NSString *materialCode = self.transParam.materialCode;//物料代码
    NSString *rrId = self.transParam.selectRegionId;//库区id
    NSString *materialStatus = self.transParam.selectStatusId;//状态
    NSString *pdate = self.transParam.selectDateStr;//生产日期
    DLog(@"padate:%@",pdate);
    DLog(@"materialCode:%@",materialCode);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",nil];
    
    if (whId) {
        [param setObject:whId forKey:@"whId"];
    }
    if (shipperCode) {
        [param setObject:shipperCode forKey:@"shipperCode"];
    }
    if (materialCode) {
        [param setObject:materialCode forKey:@"materialCode"];
    }
    if (rrId) {
        [param setObject:rrId forKey:@"rrId"];
    }
    if (materialStatus) {
        [param setObject:materialStatus forKey:@"materialStatus"];
    }
    if (pdate) {
        [param setObject:pdate forKey:@"pdate"];
    }
    [HttpTask getTransCommandLocation:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        
        if (status == 1) {
            
            self.storageLocationArr = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"data"]];
            [self.storageCollectionView reloadData];
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
        }
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 生成无单转储订单号 =================
-(void) createNoOrderTransfer
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = self.transParam.selectWhid;//仓库id
    
    NSString *updater = [[WMSUser sharedUser] userName];//操作人
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",updater,@"updater",nil];
    
    [HttpTask createNoOrderTransfer:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        
        if (status == 1) {
            self.oderId = [dictionary objectForKey:@"data"];
            
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
        }
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark =================  批量无单转储 =================
-(void) batchTransNoOrder
{
    NSMutableArray *trayCodes = [NSMutableArray array];
    for (int i=0; i<self.transParam.selectedTrayArr.count; i++) {
        WMSTray *trayModel = [WMSTray mj_objectWithKeyValues:self.transParam.selectedTrayArr[i]];
        [trayCodes addObject:trayModel.trayCode];
    }
    //NSArray *trayCodes = @[@"123",@"456"];//转储的托盘号
    NSString *orderId = self.oderId;//单据号
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = self.transParam.selectWhid;//仓库id
    NSString *fromSlId = self.transParam.fromSSid;//转储库位id
    NSString *toSlId = [NSString stringWithFormat:@"%ld",self.targetLocation.slId];//转入库位id
    NSString *operater = [[WMSUser sharedUser] userName];//操作人JSONObjectWithData
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:trayCodes
                                                       options:kNilOptions
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  orderId,@"orderId",
                                  jsonString,@"trayCodes",
                                  lcCode,@"lcCode",
                                  whId,@"whId",
                                  fromSlId,@"fromSlId",
                                  toSlId,@"toSlId",
                                  operater,@"operater",nil];
    DLog(@"param:%@",param);
    
    
    [HttpTask batchTransNoOrder:param sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *msg = [dictionary objectForKey:@"msg"];
        if ([msg isEqualToString:@"操作成功"]) {
            [self transferSuccess];
        }else{
            [[FTYToastView shareInstance] addTitle:msg addView:self.view];
        }
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 单个无单转储 托盘到托盘 =================
-(void) singleTransferNoOrder
{
    NSString *orderId = self.oderId;//明细号orderId,@"orderId",
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = self.transParam.selectWhid;//仓库id
    NSString *materialCode = self.transParam.selelctTray.materialCode;
    NSString *quantity = [NSString stringWithFormat:@"%d",self.transParam.selelctTray.quantity];
    NSString *minQuantity = [NSString stringWithFormat:@"%d",self.transParam.selelctTray.minQuantity];
    
    WMSTray *trayModel;
    if (self.transParam.selelctTray){
        
        trayModel = self.transParam.selelctTray;
    }else{
        [[FTYToastView shareInstance] addTitle:@"请选择托盘" addView:self.view];
        return;
    }
    
    NSString *fromTrayCode = self.transParam.selelctTray.trayCode;
    NSString *toTrayCode =  trayModel.trayCode;
    NSString *updater = [[WMSUser sharedUser] userCode];//用户编码
    
    NSString *pdate = self.transParam.selelctTray.pdate;
    NSString *batchNo = self.transParam.selelctTray.batchNo;
    NSString *inDate = self.transParam.selelctTray.inDate;
    NSString *shipperCode = self.transParam.selelctTray.shipperCode;
    NSString *oldMaterialStatus = [NSString stringWithFormat:@"%d",self.transParam.selelctTray.materialStatusCode];
    NSString *newMaterialStatus = [NSString stringWithFormat:@"%d",trayModel.materialStatusCode];
    //NSString *oldMaterialStatus = @"2";
    //NSString *newMaterialStatus = @"2";
    DLog(@"oldMaterialStatus：%@",oldMaterialStatus);
    DLog(@"newMaterialStatus:%@",newMaterialStatus);
    NSString *fromSlId = self.transParam.fromSSid;
    NSString *toSlId = [NSString stringWithFormat:@"%ld",_targetLocation.slId];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  orderId,@"orderId",
                                  lcCode,@"lcCode",
                                  whId,@"whId",
                                  materialCode,@"materialCode",
                                  quantity,@"quantity",
                                  minQuantity,@"minQuantity",
                                  fromTrayCode,@"fromTrayCode",
                                  toTrayCode,@"toTrayCode",
                                  updater, @"updater",
                                  pdate,@"pdate",
                                  batchNo,@"batchNo",
                                  inDate,@"inDate",
                                  shipperCode,@"shipperCode",
                                  oldMaterialStatus,@"oldMaterialStatus",
                                  newMaterialStatus,@"newMaterialStatus",
                                  fromSlId,@"fromSlId",
                                  toSlId,@"toSlId",
                                  nil];
    
    [HttpTask submitTransOperate:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *msg = [dictionary objectForKey:@"msg"];
        if ([msg isEqualToString:@"操作成功"]) {
            [self transferSuccess];
        }else{
            [[FTYToastView shareInstance] addTitle:msg addView:self.view];
        }
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

- (void)transferSuccess{
    [self clickButton:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFER_SUCCESS object:nil];
}

#pragma mark - CollectionView ---------------------------------------

//section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return _alltimeArray.count;
    return self.storageLocationArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"transferStorageCell";
    TimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"-----------------");
    }
    
    if (self.storageLocationArr.count > indexPath.row) {
        WMSStorageLocation *storage = [WMSStorageLocation mj_objectWithKeyValues:self.storageLocationArr[indexPath.row]];
        cell.timeLabel.text = storage.name;
        if (storage.capacity > storage.realCapacity) {
            //未满 天蓝色
            cell.timeLabel.backgroundColor = [FTYColor getColor:@"44bff1" andAlpha:1.0f];
        }else if (storage.capacity > storage.realCapacity) {
            //已满 红色
            cell.timeLabel.backgroundColor = [FTYColor getColor:@"ea4e3d" andAlpha:1.0f];
        }else{
            //空 白色
            cell.timeLabel.backgroundColor = [FTYColor getColor:@"ffffff" andAlpha:1.0f];
            
        }
    }
    return cell;
}



#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(viewWidth/8-1, 35);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0,0);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",@(indexPath.row).description);
    if (_storageLocationArr.count > indexPath.row) {
        WMSStorageLocation *locationModel = [WMSStorageLocation mj_objectWithKeyValues:_storageLocationArr[indexPath.row]];
        self.targetLocation = locationModel;
        if (self.transType == TransferTypeSingle) {
            [self singleTransferNoOrder];
        }else if (self.transType == TransferTypeBatch){
            [self batchTransNoOrder];
        }
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

@end
