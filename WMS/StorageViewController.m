//
//  StorageViewController.m
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "StorageViewController.h"
#import "TimeCollectionViewCell.h"
#import "TransferViewController.h"
#import "PopViewController.h"
#import "FTYColor.h"
#import "MJRefresh.h"





#define viewWidth  self.view.bounds.size.width

#define kColorBarTint   [UIColor colorWithRed:56/255.0 green:170/255.0 blue:27/255.0 alpha:1.0]

#define ZOOM_VIEW_TAG 100
#define WMS_PAGE_SIZE 20

@interface StorageViewController (){
    
}


@end

@implementation StorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [_storageCollectionView registerClass:[TimeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UIColor *color = [FTYColor getMainColorWithAlpha:1.0f];
    //self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    [self.navigationController.navigationBar setBarTintColor:color];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    //不去掉这个手势 会导致崩溃The view returned from viewForZoomingInScrollView: must be a subview of the scroll view. It can not be the scroll view itself.'
    UIGestureRecognizer *gesture = self.storageCollectionView.pinchGestureRecognizer;
    [self.storageCollectionView removeGestureRecognizer:gesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccess:) name:TRANSFER_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreData:) name:@"GetMoreData" object:nil];
    
    /*
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    */
    
    DLog(@"ScrollFrame:%@",NSStringFromCGRect(self.mScrollView.frame));
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
            self.warehouseAndRegionArr = [NSMutableArray arrayWithArray:dataArr];
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
                [self.customerArr addObjectsFromArray:[dataInfo objectForKey:@"shippers"]];
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
                [self.materialArr addObjectsFromArray:[dataInfo objectForKey:@"materials"]];
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
            
            self.storageLocationArr = [NSMutableArray arrayWithArray:[userInfo objectForKey:@"slInfos"]];
            //[self.storageCollectionView reloadData];
            float width = [[userInfo objectForKey:@"width"] floatValue];
            float length = [[userInfo objectForKey:@"length"] floatValue];
            
            self.ratio = [self calculateRadio:width andLenth:length];
            [self.storageCollectionView reloadData];
        }else{
            
            if ([FTYInfoVertifyTools isnilVertify:msg]) {
                msg = @"服务器异常，请重试！";
            }
            [[FTYToastView alloc] addTitle:msg addView:self.view];
            [self.storageLocationArr removeAllObjects];
            [self.storageCollectionView reloadData];
        }
        //[self refreshUI];
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark - 自定义方法 ---------------------------------------

- (void)refreshUI
{
    
    float ratio = self.ratio;
    
    for (int i=0; i<self.storageLocationArr.count; i++) {
        WMSStorageLocation *storage = [WMSStorageLocation mj_objectWithKeyValues:self.storageLocationArr[i]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.tag = i;
        btn.frame = CGRectMake(storage.xaxis/ratio, storage.yaxis/ratio, storage.width/ratio, storage.length/ratio);
        DLog(@"frame:%@",NSStringFromCGRect(btn.frame));
        [btn addTarget:self action:@selector(storageLactionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:storage.name forState:UIControlStateNormal];
        [self.mScrollView addSubview:btn];
        
        if (storage.capacity > storage.realCapacity) {
            //未满 天蓝色
            btn.backgroundColor = [FTYColor getColor:@"44bff1" andAlpha:1.0f];
        }else if (storage.capacity > storage.realCapacity) {
            //已满 红色
            btn.backgroundColor = [FTYColor getColor:@"ea4e3d" andAlpha:1.0f];
        }else{
            //空 白色
            btn.backgroundColor = [FTYColor getColor:@"ffffff" andAlpha:1.0f];
        }
        //btn.backgroundColor = [UIColor redColor];
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


- (void)storageLactionBtnPressed:(UIButton *)btn
{
    DLog(@"btnPressed:%ld",btn.tag);
    if (btn.tag < self.storageLocationArr.count) {
        self.selectStorage = [WMSStorageLocation mj_objectWithKeyValues:self.storageLocationArr[btn.tag]];
    }
    //如果是滑动页面 只做展示
    if (self.pageControllView == ViewTypeStorageView) {
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


- (void)resetAndGetShipper
{
    if (self.customerArr) {
        [self.customerArr removeAllObjects];
        self.shipperTotalNum = 1;
    }
    [self getCustomer];
}

- (void)resetAndGetMaterial
{
    if (self.materialArr) {
        [self.materialArr removeAllObjects];
        self.materialTotalNum = 1;
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
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.storageCollectionView;
    //return [scrollView viewWithTag:ZOOM_VIEW_TAG];
}


//代理方法 ,点击即可dismiss掉每次init产生的PopViewController
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
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
    return [self.storageLocationArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    TimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"-----------------");
    }
    /*
    for (NSUInteger i = 0; i< _alltimeArray.count; i++) {
        if (indexPath.row == i) {
            cell.timeLabel.text = _alltimeArray[i];
            //cell.timeLabel.textColor = [UIColor redColor];
        }
    }
    
    if (indexPath.row % 5 == 0) {
        cell.timeLabel.backgroundColor = [FTYColor getColor:@"44bff1" andAlpha:1.0f];
    }
    if (indexPath.row % 11 == 0) {
        cell.timeLabel.backgroundColor = [FTYColor getColor:@"ea4e3d" andAlpha:1.0f];
    }*/
    
    
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
    
    return CGSizeMake(viewWidth/11-1, 35);
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
    
    if (indexPath.row < self.storageLocationArr.count) {
        self.selectStorage = [WMSStorageLocation mj_objectWithKeyValues:self.storageLocationArr[indexPath.row]];
    }
    //如果是滑动页面 只做展示
    if (self.pageControllView == ViewTypeStorageView) {
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
    
    //[self.navigationController pushViewController:detailControllrer animated:YES];
    
    
    //[self transferSuccess:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
