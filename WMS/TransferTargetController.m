//
//  TransferTargetController.m
//  WMS
//
//  Created by wandou on 2017/8/31.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "TransferTargetController.h"
#import "PanCollectionViewCell.h"
#import "StorageCollectionViewCell.h"
#import "FTYColor.h"
#import "TransferViewController.h"
#import "WMSSelect.h"

@interface TransferTargetController ()

@end

@implementation TransferTargetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_dataArr) {
        _dataArr = [[NSArray alloc]init];
        _dataArr = @[@"001",@"002",@"003",@"004",@"005",@"006",@"007",@"008",@"009",@"010",@"011",@"012",@"013",@"014",@"015",@"016"];
        
    }
    
    self.title = @"目标托盘";
    
    _bgView.backgroundColor = [FTYColor getColor:@"f7fcff" andAlpha:1.0f];
    _bgView.layer.borderColor = [FTYColor getColor:@"ebecec" andAlpha:1.0f].CGColor;
    _bgView.layer.borderWidth = 1.0;
    [_bgView.layer setMasksToBounds:YES];
    _bgView.layer.cornerRadius = 5;
    self.selectLocationIndex = -1;//需要赋初始值
    self.selectPanIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
}
#pragma mark ================= 获取数据接口 =================
- (void)getData {
    //生成拣货单号
    [self createNoOrderTransfer];
    //获取推荐库位信息
    [self getCommendLocation];
    //[self judgeTrayTransfer];
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
    BOOL isEmpty = self.transParam.empty;
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
    if (isEmpty){
        [param setObject:@"1" forKey:@"empty"];
    }
    [HttpTask getTransCommandLocation:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        
        if (status == 1) {
            if ([dictionary objectForKey:@"data"]) {
                self.commendLocationArr = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"data"]];
                [self.storageCollectionView reloadData];
            }
            
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
        }
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 1 获取库位下的托盘 =================
-(void) getTrayBySlId
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    //NSString *whId = @"192";//仓库id
    //NSString *slId = @"30132";//库位id
    NSString *whId = self.transParam.selectWhid;//仓库id
    NSString *slId = [NSString stringWithFormat:@"%ld",self.targetLocation.slId];//库位id
    NSString *shipperCode = self.transParam.selelctTray.shipperCode;
    NSString *material = self.transParam.selelctTray.materialCode;
    DLog(@"material:%@",material);
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",
                                  whId,@"whId",slId,@"slId",
                                  shipperCode,@"shipperCode",
                                  material,@"material",
                                  nil];
    DLog(@"param:%@",param);
    [HttpTask getTrayBySlId:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        //NSDictionary *userInfo = [dictionary objectForKey:@"data"];
        
        
        if (status == 1) {
            if ([dictionary objectForKey:@"data"]) {
                NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"data"]];
                //dataArr objectAtIndex:<#(NSUInteger)#>
                self.panArr = [[NSMutableArray alloc] init];
                for (int i=0; i<[dataArr count]; i++) {
                    WMSTray *trayModel = [WMSTray mj_objectWithKeyValues:dataArr[i]];
                    [self.panArr addObject:trayModel];
                }
                [self.panCollectionView reloadData];
            }
            
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
        }
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}


#pragma mark ================= 判断是否可转储 =================
-(void) judgeTrayTransfer
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = @"192";//仓库id
    NSString *orderItemId = @"ZCG04620171115000011";//明细号
    
    NSString *trayCode = @"192";//托盘码
    NSString *boxCode = @"30132";//箱码
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",orderItemId,@"orderItemId",trayCode, @"trayCode",boxCode,@"boxCode",nil];
    DLog(@"param:%@",param);
    [HttpTask judgeTrayTransfer:param sucessBlock:^(NSString *responseStr) {
        
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
            if ([dictionary objectForKey:@"data"]) {
                self.oderId = [dictionary objectForKey:@"data"];
            }
            
            
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
    
    
    DLog(@"_selectPanIndex:%ld",_selectPanIndex);
    WMSTray *trayModel;
    if (_panArr.count>_selectPanIndex) {
        trayModel = [WMSTray mj_objectWithKeyValues:_panArr[_selectPanIndex]];
    }else if (self.transParam.selelctTray){
        
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
    if (self.transType == TransferTypeSingle) {
        [self singleTransferNoOrder];
    }else if (self.transType == TransferTypeBatch){
        [self batchTransNoOrder];
    }
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
    //return _dataArr.count;
    if (collectionView == _storageCollectionView) {
        return _commendLocationArr.count;
    }else if (self.transType == TransferTypeSingle){
        return _panArr.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _storageCollectionView) {
        StorageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StorageCollectionViewCell" forIndexPath:indexPath];
        [cell sizeToFit];
        int index = indexPath.row % 4;
        switch (index) {
            case 0:
                cell.backgroundColor = [FTYColor getColor:@"45bef5" andAlpha:1.0f];
                break;
            case 1:
                cell.backgroundColor = [FTYColor getColor:@"dd4931" andAlpha:1.0f];
                break;
            case 2:
                cell.backgroundColor = [FTYColor getColor:@"25a858" andAlpha:1.0f];
                break;
            case 3:
                cell.backgroundColor = [FTYColor getColor:@"f59c01" andAlpha:1.0f];
                break;
            default:
                break;
        }
        cell.layer.cornerRadius = 5;
        
        if (indexPath.row < _commendLocationArr.count) {
            WMSStorageLocation *locationModel = [WMSStorageLocation mj_objectWithKeyValues:_commendLocationArr[indexPath.row]];
            //DLog(@"locationModel:%@",locationModel.num);
            cell.locationNameLb.text = locationModel.name;
            cell.capacityLb.text = [NSString stringWithFormat:@"托盘:%d/%d",locationModel.realCapacity,locationModel.capacity];
            
            
            if (indexPath.row == self.selectLocationIndex) {
                [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"radio_check"] forState:UIControlStateNormal];
            }else{
                [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"radio_uncheck"] forState:UIControlStateNormal];
            }
            /*
            cell.checkBtn.tag = indexPath.row;
            
            cell.storageSelected = ^(WMSSelect* selection){
                DLog(@"storageSelected:%ld",selection.index);
                
                if (selection.isCheck) {
                    self.targetLocation = locationModel;
                    self.selectLocationIndex = selection.index;
                    [self getTrayBySlId];
                }
                [self.storageCollectionView reloadData];
            };
            */
        }
        
        return cell;
    }else{
        PanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PanCollectionViewCell" forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"-----------------");
        }
        if (indexPath.row < self.panArr.count) {
            
            WMSTray *trayModel = [WMSTray mj_objectWithKeyValues:_panArr[indexPath.row]];
            DLog(@"托盘:%@",trayModel.minUnit);
            DLog(@"托盘:%d",trayModel.minQuantity);
            cell.panTitle.text = trayModel.trayCode;
            cell.productName.text = trayModel.materialName;
            cell.productNum.text = [NSString stringWithFormat:@"%d %@",trayModel.quantity,trayModel.unit];
            cell.productSaleUnit.text = [NSString stringWithFormat:@"%d %@",trayModel.minQuantity,trayModel.minUnit];
            cell.panRule.text = [NSString stringWithFormat:@"%d",trayModel.plateCount];
            cell.productDate.text = trayModel.pdate;
            cell.batchNum.text = trayModel.batchNo;
            cell.productStatus.text = trayModel.materialStatus;
            
            if (indexPath.row == self.selectPanIndex) {
                [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"box_check"] forState:UIControlStateNormal];
            }else{
                [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"box_uncheck"] forState:UIControlStateNormal];
            }
        }
        
        int index = indexPath.row % 4;
        switch (index) {
            case 0:
                cell.backgroundColor = [FTYColor getColor:@"45bef5" andAlpha:1.0f];
                break;
            case 1:
                cell.backgroundColor = [FTYColor getColor:@"dd4931" andAlpha:1.0f];
                break;
            case 2:
                cell.backgroundColor = [FTYColor getColor:@"25a858" andAlpha:1.0f];
                break;
            case 3:
                cell.backgroundColor = [FTYColor getColor:@"f59c01" andAlpha:1.0f];
                break;
            default:
                break;
        }
        
        cell.layer.borderColor = [FTYColor getColor:@"ebecec" andAlpha:1.0f].CGColor;
        cell.layer.borderWidth = 1.0;
        [cell.layer setMasksToBounds:YES];
        cell.layer.cornerRadius = 5;
        return cell;
    }
    
    return nil;
}


#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.frame.size.width/5.0f;
    
    if (collectionView == _storageCollectionView) {
        
        return CGSizeMake(width, width-50);
    }else{
        
        return CGSizeMake(width, width);
    }
    
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0,0);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",@(indexPath.row).description);
   
    if (collectionView == _storageCollectionView){
        if (_commendLocationArr.count > indexPath.row) {
            self.selectLocationIndex = indexPath.row;
            self.selectPanIndex = -1;
            WMSStorageLocation *locationModel = [WMSStorageLocation mj_objectWithKeyValues:_commendLocationArr[indexPath.row]];
            self.targetLocation = locationModel;
            [self getTrayBySlId];
            [self.storageCollectionView reloadData];
        }
        
    }else{
        self.selectPanIndex = indexPath.row;
        [self.panCollectionView reloadData];
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
