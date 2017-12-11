//
//  StorageLocationViewController.m
//  WMS
//
//  Created by wandou on 04/12/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import "StorageLocationViewController.h"
#import "TransferViewController.h"
#import "PopViewController.h"
#import "FTYColor.h"
#import "MJRefresh.h"
#import "WMSStorageLocation.h"

#define viewWidth  self.view.bounds.size.width

#define kColorBarTint   [UIColor colorWithRed:56/255.0 green:170/255.0 blue:27/255.0 alpha:1.0]

#define ZOOM_VIEW_TAG 100
#define WMS_PAGE_SIZE 20

@interface StorageLocationViewController ()

@end

@implementation StorageLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccess:) name:TRANSFER_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreData:) name:@"GetMoreData" object:nil];
    self.mScrollView.frame = CGRectMake(0, 233, 1024, 495);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //如果是滑动页面 只做展示
    if (self.pageControllView == ViewTypeStorageView) {
        self.backBtn.hidden = YES;
    }else{
        self.backBtn.hidden = NO;
    }
    self.materialTotalNum = 1;
    self.shipperTotalNum = 1;
    [self getWarehouseAndRegion];
    [self getCustomer];
    [self getMaterial];
    
}
#pragma mark ================= 监听方法 =================
- (void)getMoreData:(NSNotification *)notify
{
    NSString *name = [notify object];
    if ([_curSelectType isEqualToString:@"WarehouseManageSelectShipper"]) {
        
        [self getCustomer];
    }else if ([_curSelectType isEqualToString:@"WarehouseManageSelectMaterial"]){
        [self getMaterial];
    }
}
#pragma mark ================= 获取数据方法 =================
#pragma mark ================= 获取仓库及下属库区 =================

-(void) getWarehouseAndRegion
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
        NSArray *dataArr = [dictionary objectForKey:@"data"];
        
        if (status == 1) {
            if (dataArr) {
                self.warehouseAndRegionArr = [NSMutableArray arrayWithArray:dataArr];
            }
            
            if (self.warehouseAndRegionArr.count > 0) {
                _selectWareHouse = [WMSWareHouse mj_objectWithKeyValues:_warehouseAndRegionArr[0]];
                [self.wareHouseBtn setTitle:_selectWareHouse.name forState:UIControlStateNormal];
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

#pragma mark =================  分页获取物流中心下货主 =================
-(void) getCustomer
{
    if (self.customerArr == nil) {
        self.customerArr = [[NSMutableArray alloc] init];
    }
    
    
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *pageSize = @"10";//分页大小
    NSInteger pagenum = self.customerArr.count/pageSize.integerValue + 1;
    if (self.customerArr.count < _shipperTotalNum) {
        NSString *pageNo = [NSString stringWithFormat:@"%ld",pagenum];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",pageSize,@"pageSize",pageNo,@"pageNo",nil];
        NSString *selectShipper = self.shipperField.text;
        if (self.shipperField.text) {
            [param setObject:selectShipper forKey:@"name"];
        }
        
        [HttpTask getCustomer:param sucessBlock:^(NSString *responseStr) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSNumber *statusNum = [dictionary objectForKey:@"success"];
            
            NSInteger status = [statusNum integerValue];
            NSString *msg = [dictionary objectForKey:@"msg"];
            NSDictionary *dataInfo = [dictionary objectForKey:@"data"];
            
            
            if (status == 1) {
                self.shipperTotalNum = [[dataInfo objectForKey:@"total"] integerValue];
                DLog(@"pagenum:%@",pageNo);
                if ([dataInfo objectForKey:@"shippers"]) {
                    [self.customerArr addObjectsFromArray:[dataInfo objectForKey:@"shippers"]];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DidGetMoreData" object:nil];
            }else{
                
                if ([FTYInfoVertifyTools isnilVertify:msg]) {
                    msg = @"服务器异常，请重试！";
                }
                [[FTYToastView alloc] addTitle:msg addView:self.view];
            }
        } failBlock:^(NSDictionary *errDict) {
            
        }];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidGetMoreData" object:@"NoMoreData"];
    }
    
}

#pragma mark =================  分页物料查询 =================
-(void) getMaterial
{
    if (self.materialArr == nil) {
        self.materialArr = [[NSMutableArray alloc] init];
    }
    
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *barCode = @"";//条码
    NSString *pageSize = @"10";//分页大小
    NSInteger pagenum = self.materialArr.count/pageSize.integerValue + 1;
    
    if (self.materialArr.count < self.materialTotalNum) {
        NSString *pageNo = [NSString stringWithFormat:@"%ld",pagenum];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",barCode,@"barCode",pageSize,@"pageSize",pageNo,@"pageNo",nil];
        NSString *shipperCode = self.selectShipper.code;
        NSString *materialName = self.materialField.text;
        if (shipperCode) {
            [param setObject:shipperCode forKey:@"shipperCode"];
        }
        if (materialName) {
            [param setObject:materialName forKey:@"materialName"];
        }
        
        DLog(@"param:%@",param);
        [HttpTask getMaterial:param sucessBlock:^(NSString *responseStr) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSNumber *statusNum = [dictionary objectForKey:@"success"];
            
            NSInteger status = [statusNum integerValue];
            NSString *msg = [dictionary objectForKey:@"msg"];
            NSDictionary *dataInfo = [dictionary objectForKey:@"data"];
            
            
            if (status == 1) {
                self.materialTotalNum = [[dataInfo objectForKey:@"total"] integerValue];
                if ([dataInfo objectForKey:@"materials"]) {
                    [self.materialArr addObjectsFromArray:[dataInfo objectForKey:@"materials"]];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DidGetMoreData" object:nil];
                
            }else{
                
                if ([FTYInfoVertifyTools isnilVertify:msg]) {
                    msg = @"服务器异常，请重试！";
                }
                [[FTYToastView alloc] addTitle:msg addView:self.view];
            }
        } failBlock:^(NSDictionary *errDict) {
            
        }];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidGetMoreData" object:@"NoMoreData"];
    }
    
}

#pragma mark ================= 获取库位信息 =================
-(void) getStorageLocationInfo
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = self.selectWareHouse.whId;//仓库id: whid 例如：191
    NSString *rrId = self.selectRegion.rrId;//库区id: rrId
    NSString *shipperCode = _selectShipper.code;
    NSString *materialCode = _selectWMSMaterial.code;
    
    DLog(@"shipperCode:%@",shipperCode);
    DLog(@"materialCode:%@",materialCode);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",nil];
    if (whId) {
        [param setObject:whId forKey:@"whId"];
    }
    if (rrId) {
        [param setObject:rrId forKey:@"rrId"];
    }
    if (shipperCode) {
        [param setObject:shipperCode forKey:@"shipperCode"];
    }
    if (materialCode) {
        [param setObject:materialCode forKey:@"materialCode"];
    }
    
    
    
    
    [HttpTask getSlInfo:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        NSDictionary *userInfo = [dictionary objectForKey:@"data"];
        
        
        if (status == 1) {
            
            if ([userInfo objectForKey:@"slInfos"]) {
                self.storageLocationArr = [NSMutableArray arrayWithArray:[userInfo objectForKey:@"slInfos"]];
            }
            
            //[self.storageCollectionView reloadData];
            float width = [[userInfo objectForKey:@"width"] floatValue];
            float length = [[userInfo objectForKey:@"length"] floatValue];
            self.wareHouseWidth = width;
            self.wareHouseHeight = length;
            
            self.ratio = [self calculateRadio:width andLenth:length];
            
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
            [self.storageLocationArr removeAllObjects];
            
        }
        [self refreshUI];
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

- (void)refreshUI
{
    float ratio = self.ratio;
    DLog(@"ratio:%f",ratio);
    //ratio = 0.5;
    //[self.mScrollView removeFromSuperview];
    //self.mScrollView = [[UIScrollView alloc] init];
    //self.mScrollView.frame = CGRectMake(0, 233, 1024, 495);
    
    //self.mScrollView.delegate = self;
    //[self.view addSubview:self.mScrollView];
    
    self.mScrollView.maximumZoomScale = 5;
    self.mScrollView.minimumZoomScale = 1.0;
    CGSize btnViewSize;
    if (self.wareHouseHeight>0 && self.wareHouseWidth>0) {
        btnViewSize = CGSizeMake(self.wareHouseWidth, self.wareHouseHeight);
    }else{
        btnViewSize = self.mScrollView.frame.size;
    }
    
    [self.btnBgView removeFromSuperview];
    self.btnBgView = nil;
    //self.btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnViewSize.width,btnViewSize.height)];
    self.btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnViewSize.width,btnViewSize.height)];
    [self.mScrollView addSubview:self.btnBgView];
    
    //self.btnView.backgroundColor = [UIColor greenColor];
    DLog(@"mScrollView frame:%@",NSStringFromCGRect(_mScrollView.frame));
    //DLog(@"btnView frame:%@",NSStringFromCGRect(_btnView.frame));
    for (int i=0; i<self.storageLocationArr.count; i++) {
        WMSStorageLocation *storage = [WMSStorageLocation mj_objectWithKeyValues:self.storageLocationArr[i]];
        
        if (storage.xaxis>=0 && storage.yaxis>=0 && storage.width>0 && storage.length>0) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            //btn.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.tag = i;
            //btn.frame = CGRectMake(storage.xaxis/ratio, storage.yaxis/ratio, storage.width/ratio, storage.length/ratio);
            btn.frame = CGRectMake(storage.xaxis, storage.yaxis, storage.width, storage.length);
            //DLog(@"frame:%@",NSStringFromCGRect(btn.frame));
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            //[btn setTitle:storage.name forState:UIControlStateNormal];
            //[btn.layer setBorderWidth:0.5];
            //[btn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            //[self.btnBgView addSubview:btn];
            
            UILabel *titleLb = [[UILabel alloc] initWithFrame:btn.frame];
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
            //titleLb.backgroundColor = [UIColor clearColor];
           /*
            if (storage.capacity > storage.realCapacity) {
                //未满 天蓝色
                titleLb.backgroundColor = [FTYColor getColor:@"44bff1" andAlpha:1.0f];
            }else if (storage.realCapacity >= storage.capacity && storage.realCapacity>0) {
                //已满 红色
                titleLb.backgroundColor = [FTYColor getColor:@"ea4e3d" andAlpha:1.0f];
            }else{
                //空 白色
                titleLb.backgroundColor = [FTYColor getColor:@"ffffff" andAlpha:1.0f];
            }
            */
            
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
    self.wareHouseWidth = slWidth;
    self.wareHouseHeight = slLength;
    float ratioy = slLength/size.height;
    return  ratiox > ratioy ? ratiox : ratioy;
    //return ratiox;
}

- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    UILabel *label=(UILabel*)recognizer.view;
    NSLog(@"%@被点击了",label.text);
    DLog(@"btnPressed:%ld",label.tag);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGAffineTransform newTransform =  CGAffineTransformScale(label.transform, 1.5, 1.5);//2,2表示放大的大小
        
        label.transform = newTransform;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
        } completion:^(BOOL finished) {
            
            CGAffineTransform newTransform =  CGAffineTransformScale(label.transform, 1/1.5, 1/1.5);//2,2表示放大的大小
            
            label.transform = newTransform;
            
        }];
        
    }];
    
    if (label.tag < self.storageLocationArr.count) {
        self.selectStorage = [WMSStorageLocation mj_objectWithKeyValues:self.storageLocationArr[label.tag]];
    }
    //如果是滑动页面 只做展示
    if (self.pageControllView == ViewTypeStorageView || self.selectStorage.realCapacity == 0) {
        return;
    }
    
    
    TransferViewController *transferViewController =
    [[TransferViewController alloc] init];
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    UINavigationController  *detailControllrer = [board instantiateViewControllerWithIdentifier: @"NavTransferViewController"];
    //detailControllrer = [board instantiateViewControllerWithIdentifier: @"TransferViewController"];
    //[detailControllrer setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];UIModalPresentationOverFullScreen
    //[detailControllrer setModalPresentationStyle:UIModalPresentationFormSheet];
    [detailControllrer setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentModalViewController:detailControllrer animated:YES];
    
    transferViewController = (TransferViewController *)detailControllrer.topViewController;
    transferViewController.selectWareHouse = self.selectWareHouse;
    transferViewController.selectWhId = self.selectWareHouse.whId;
    transferViewController.selectSlId = [NSString stringWithFormat:@"%ld",self.selectStorage.slId];
    transferViewController.shipperCode = self.selectShipper.code;
    transferViewController.materialCode = self.selectWMSMaterial.code;
    
    DLog(@"selectWhId:%@",transferViewController.selectWhId);
    DLog(@"selectSlId:%@",transferViewController.selectSlId);
    DLog(@"materialCode:%@",transferViewController.materialCode);
}
- (void)btnPressed:(UIButton *)btn
{
    
}
//重置库区
- (void)resetRegion
{
   [self.regionBtn setTitle:@"请选择库区" forState:UIControlStateNormal];
    _selectRegion = nil;
}
//重置货主
- (void)resetAndGetShipper
{
    if (self.customerArr) {
        [self.customerArr removeAllObjects];
        self.shipperTotalNum = 1;
        _selectShipper = nil;
    }
    [self getCustomer];
}
//重置物料
- (void)resetAndGetMaterial
{
    if (self.materialArr) {
        [self.materialArr removeAllObjects];
        self.materialTotalNum = 1;
        _selectWMSMaterial = nil;
    }
    [self getMaterial];
}

/*
 - (void)hideKeyboard:(UITapGestureRecognizer *)tap
 {
 if ([tap isKindOfClass:[UITapGestureRecognizer class]] ) {
 [self.shipperField resignFirstResponder];
 [self.materialField resignFirstResponder];
 }
 }
 */
//弹出popview 选择视图
- (IBAction)showDock:(UIButton *)sender {
    
    [self.shipperField resignFirstResponder];
    [self.materialField resignFirstResponder];
    switch (sender.tag) {
        case WarehouseManageSelectWarehouse:
            //选择仓库
            self.curSelectType = @"WarehouseManageSelectWarehouse";
            break;
        case WarehouseManageSelectRegion:
            //选择库区
        {
            self.curSelectType = @"WarehouseManageSelectRegion";
            if (self.selectWareHouse == nil) {
                [[FTYToastView alloc] addTitle:@"请先选择所属仓库！" addView:self.view];
                return;
            }
        }
            break;
        case WarehouseManageSelectShipper:
            //选择货主
        {
            self.curSelectType = @"WarehouseManageSelectShipper";
            if (self.shipperField.text != nil) {
                self.searchText = self.shipperField.text;
                DLog(@"searchText:%@",self.searchText);
            }
        }
            break;
        case WarehouseManageSelectMaterial:
            //选择物料
        {
            self.curSelectType = @"WarehouseManageSelectMaterial";
            if (self.materialField.text != nil) {
                self.searchText = self.materialField.text;
                DLog(@"searchText:%@",self.searchText);
            }
        }
            break;
        default:
            break;
    }
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    PopViewController *popController = [board instantiateViewControllerWithIdentifier: @"PopViewController"];
    
    [popController setModalPresentationStyle:UIModalPresentationPopover];
    
    [self presentViewController:popController animated:YES completion:nil];
    //[self.navigationController presentViewController:popController animated:YES completion:nil];
    popController.popoverPresentationController.sourceView = sender;
    popController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.popoverPresentationController.delegate = self;
    //popController.popoverPresentationController.backgroundColor = [UIColor blackColor];
    popController.preferredContentSize = CGSizeMake(PopViewWidth, self.view.frame.size.height);
    
    popController.dataArr = [self getPopviewData:sender];
    popController.curType = self.curSelectType;
    
    popController.block = ^(WMSSelect *selectModel){
        //sender.titleLabel.text = selectModel.title;
        [sender setTitle:selectModel.title forState:UIControlStateNormal];
        selectModel.selectType = sender.tag;
        [self recordUserSelection:selectModel];
    };
}

//获取库位
- (IBAction)searchStorageLocation:(UIButton *)sender
{
    [self getStorageLocationInfo];
}

//清空查询
- (IBAction)clearSearch:(UIButton *)sender
{
    
    if (_warehouseAndRegionArr.count > 0) {
        _selectWareHouse = [WMSWareHouse mj_objectWithKeyValues:_warehouseAndRegionArr[0]];
    }
    _selectRegion = nil;
    _selectShipper = nil;
    _selectWMSMaterial = nil;
    
    NSString *wareHouseName = _selectWareHouse.name;
    if (wareHouseName) {
        [self.wareHouseBtn setTitle:wareHouseName forState:UIControlStateNormal];
    }else{
        [self.wareHouseBtn setTitle:@"请选择仓库" forState:UIControlStateNormal];
    }
    
    [self.regionBtn setTitle:@"请选择库区" forState:UIControlStateNormal];
    //[self.shipperBtn setTitle:@"请选择货主" forState:UIControlStateNormal];
    //[self.materialBtn setTitle:@"请选择物料" forState:UIControlStateNormal];
    self.shipperField.placeholder = @"请选择货主";
    self.materialField.placeholder = @"请选择物料";
    self.shipperField.text = nil;
    self.materialField.text = nil;
    [self resetAndGetShipper];
    [self resetAndGetMaterial];
}

//返回
- (IBAction)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSMutableArray *)getPopviewData:(UIButton *)sender
{
    
    switch (sender.tag) {
        case WarehouseManageSelectWarehouse:
            //选择仓库
            
            return self.warehouseAndRegionArr;
            
            break;
        case WarehouseManageSelectRegion:
            //选择库区
            if (self.selectWareHouse == nil) {
                [[FTYToastView alloc] addTitle:@"请先选择所属仓库！" addView:self.view];
            }else{
                return self.selectWareHouse.rrInfo;
            }
            break;
        case WarehouseManageSelectShipper:
            //选择货主
        {
            return self.customerArr;
        }
            break;
        case WarehouseManageSelectMaterial:
            //选择物料
        {
            return self.materialArr;
        }
            break;
        default:
            break;
    }
    
    return nil;
}


- (void)recordUserSelection:(WMSSelect *)sender
{
    switch (sender.selectType) {
        case WarehouseManageSelectWarehouse:
            //选择仓库
        {
            if (_warehouseAndRegionArr.count > sender.index) {
                _selectWareHouse = [WMSWareHouse mj_objectWithKeyValues:_warehouseAndRegionArr[sender.index]];
                [self resetRegion];
            }
        }
            break;
        case WarehouseManageSelectRegion:
            //选择库区
        {
            if (_selectWareHouse.rrInfo.count > sender.index) {
                _selectRegion = [WMSRegion mj_objectWithKeyValues:_selectWareHouse.rrInfo[sender.index]];
            }
        }
            break;
        case WarehouseManageSelectShipper:
            //选择货主
        {
            if (_customerArr.count > sender.index) {
                self.selectShipper = [WMSShipper mj_objectWithKeyValues:_customerArr[sender.index]];
                DLog(@"_selectShipper:%@",_selectShipper.code);
                self.shipperField.text = _selectShipper.name;
                DLog(@"_selectWMSShipper.title:%@",_selectShipper.title);
            }
        }
            break;
        case WarehouseManageSelectMaterial:
            //选择物料
        {
            if (_materialArr.count > sender.index) {
                self.selectWMSMaterial = [WMSMaterial mj_objectWithKeyValues:_materialArr[sender.index]];
                
                DLog(@"_selectWMSMaterial:%@",_selectWMSMaterial.code);
                self.materialField.text = _selectWMSMaterial.name;
                DLog(@"_selectWMSMaterial.title:%@",_selectWMSMaterial.title);
            }
        }
            break;
        default:
            break;
    }
}


- (void)transferSuccess:(NSNotification *)notify
{
    
    ScottCustomAlertView *customAlertView = [ScottCustomAlertView createViewFromNib];
    customAlertView.layer.cornerRadius = 5;
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:customAlertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertController.tapBackgroundDismissEnable = YES;
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
    
    /*
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SUCCESS" message:@"恭喜您已经转储成功" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
     [alertController addAction:okAction];
     
     [self.navigationController presentViewController:alertController animated:YES completion:nil];
     */
    
    /*
     UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"这个是UIAlertView的默认样式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
     [alertview show];
     
     */
    
}


#pragma mark ================= textField Delegate =================
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //清空原有数据
    if (textField == _shipperField) {
        [self resetAndGetShipper];
    }
    [self resetAndGetMaterial];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark ================= UIScrollView Delegate =================

//缩放过程中的图像
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    for (UIView *view in scrollView.subviews) {
//        return view;
//    }
    return self.btnBgView;
    return nil;
}

//缩放结束
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"缩放的比例:%f",scale);
    for (UIView *view in self.btnBgView.subviews) {
       
        if ([view isKindOfClass:[UILabel class]]) {
            
            [view.layer setContentsScale:scale*[[UIScreen mainScreen] scale]];
            [view.layer setNeedsDisplay];
        
            
        }
    }
    
//    for (UIView *view in scrollView.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view.layer setContentsScale:scale*[[UIScreen mainScreen] scale]];
//            [view.layer setNeedsDisplay];
//        }
//    }
}

//缩放中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"缩放中");
}

//代理方法 ,点击即可dismiss掉每次init产生的PopViewController
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.mScrollView = nil;
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
