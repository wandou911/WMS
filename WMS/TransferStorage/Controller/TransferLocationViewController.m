//
//  TransferLocationViewController.m
//  WMS
//
//  Created by wandou on 05/12/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import "TransferLocationViewController.h"

@interface TransferLocationViewController ()

@end

@implementation TransferLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"目标库位展示";
    //self.mScrollView.backgroundColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createNoOrderTransfer];
    [self getCommendLocation];
}

#pragma mark ================= 自定义方法 =================

- (IBAction)goBack:(id)sender {
    
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
        
        if (status == 1 && [dictionary objectForKey:@"data"]) {
            
            self.storageLocationArr = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"data"]];
            //[self.storageCollectionView reloadData];
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
        }
        
        [self refreshUI];
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
        
        if (status == 1 && [dictionary objectForKey:@"data"]) {
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

- (void)refreshUI
{
    self.mScrollView.maximumZoomScale = 5;
    self.mScrollView.minimumZoomScale = 1.0;
    [self.btnBgView removeFromSuperview];
    self.btnBgView = nil;
    
    CGSize btnViewSize;
    if (self.wareHouseHeight>0 && self.wareHouseWidth>0) {
        btnViewSize = CGSizeMake(self.wareHouseWidth, self.wareHouseHeight);
    }else{
        btnViewSize = self.mScrollView.frame.size;
    }
    self.btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnViewSize.width, btnViewSize.height)];
    [self.mScrollView addSubview:self.btnBgView];
    for (int i=0; i<self.storageLocationArr.count; i++) {
        WMSStorageLocation *storage = [WMSStorageLocation mj_objectWithKeyValues:self.storageLocationArr[i]];
        if (storage.xaxis>=0 && storage.yaxis>=0 && storage.width>0 && storage.length>0) {
            
            CGRect lbFrame = CGRectMake(storage.xaxis, storage.yaxis, storage.width, storage.length);
            UILabel *titleLb = [[UILabel alloc] initWithFrame:lbFrame];
            [self.btnBgView addSubview:titleLb];
            titleLb.text = storage.name;
            titleLb.tag = i;
            //titleLb.numberOfLines = 0;
            titleLb.adjustsFontSizeToFitWidth = YES;
            titleLb.textAlignment = NSTextAlignmentCenter;
            titleLb.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
            [titleLb addGestureRecognizer:labelTapGestureRecognizer];
            titleLb.userInteractionEnabled = YES;
            
            if (storage.realCapacity == 0) {
                //空 白色
                titleLb.backgroundColor = [FTYColor getColor:@"f2f2f2" andAlpha:1.0f];
            }else if(storage.realCapacity>0 && storage.realCapacity<storage.capacity){
                //未满 天蓝色
                titleLb.backgroundColor = [FTYColor getColor:@"44bff1" andAlpha:1.0f];
            }else if(storage.realCapacity >= storage.capacity){
                //已满 红色
                titleLb.backgroundColor = [FTYColor getColor:@"ea4e3d" andAlpha:1.0f];
            }else{
                //其他 白色
                titleLb.backgroundColor = [FTYColor getColor:@"ffffff" andAlpha:1.0f];
            }
        }
        
    }
}

- (float)calculateRadio:(float)slWidth andLenth:(float)slLength
{
    CGSize size = self.mScrollView.frame.size;
    DLog(@"frame:%@",NSStringFromCGRect(self.mScrollView.frame));
    float ratiox = slWidth/size.width;
    float ratioy = slLength/size.height;
    return  ratiox > ratioy ? ratiox : ratioy;
}

- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    UILabel *label=(UILabel*)recognizer.view;
    NSLog(@"%@被点击了",label.text);
    DLog(@"btnPressed:%ld",label.tag);
    [UIView animateWithDuration:0.5 animations:^{
        
        CGAffineTransform newTransform =  CGAffineTransformScale(label.transform, 2, 2);//2,2表示放大的大小
        
        label.transform = newTransform;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
        } completion:^(BOOL finished) {
            
            CGAffineTransform newTransform =  CGAffineTransformScale(label.transform, 0.5, 0.5);//2,2表示放大的大小
            
            label.transform = newTransform;
            
        }];
        
    }];
    if (_storageLocationArr.count > label.tag) {
        WMSStorageLocation *locationModel = [WMSStorageLocation mj_objectWithKeyValues:_storageLocationArr[label.tag]];
        self.targetLocation = locationModel;
        if (self.transType == TransferTypeSingle) {
            [self singleTransferNoOrder];
        }else if (self.transType == TransferTypeBatch){
            [self batchTransNoOrder];
        }
    }
}
- (void)btnPressed:(UIButton *)btn
{
    DLog(@"btnPressed:%ld",btn.tag);
}

#pragma mark ================= UIScrollView Delegate =================

//缩放过程中的图像
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    for (UIView *view in scrollView.subviews) {
//        return view;
//    }
    return self.btnBgView;
    
}

//缩放结束
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"缩放的比例:%f",scale);
}

//缩放中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"缩放中");
}

- (void)transferSuccess{
    [self clickButton:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFER_SUCCESS object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
