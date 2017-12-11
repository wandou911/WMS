//
//  TransferViewController.m
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "TransferViewController.h"
#import "TimeCollectionViewCell.h"
#import "PanTableViewCell.h"
#import "FTYColor.h"
#import "PanCollectionViewCell.h"
#import "TransferTargetController.h"
#import "PopViewController.h"


@interface TransferViewController ()

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //这个是数据源
    if (!_alltimeArray) {
        _alltimeArray = [[NSArray alloc]init];
        _alltimeArray = @[@"8.00",@"9.00",@"10.00",@"11.00",@"12.00",@"13.00",@"14.00",@"15.00",@"16.00",@"17.00",@"18.00",@"19.00",@"20.00",@"21.00",@"22.00",@"23.00"];
        
    }
    
    [_transferCollectionView registerClass:[TimeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_panTableView registerClass:[PanTableViewCell class] forCellReuseIdentifier:@"RecipeCell"];
    //[self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    self.title = @"转储";
    
    //_remarkTextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _remarkTextView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _remarkTextView.layer.borderWidth = 1.0;
    [_remarkTextView.layer setMasksToBounds:YES];
    _remarkTextView.layer.cornerRadius = 5;
    
    _bgView.backgroundColor = [FTYColor getColor:@"f7fcff" andAlpha:1.0f];
    _bgView.layer.borderColor = [FTYColor getColor:@"ebecec" andAlpha:1.0f].CGColor;
    _bgView.layer.borderWidth = 1.0;
    [_bgView.layer setMasksToBounds:YES];
    _bgView.layer.cornerRadius = 5;
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 50; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image = [UIImage imageNamed:@"btn_pulldown"];
    // 指定为拉伸模式，伸缩后重新赋值
   image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.dateBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.statusBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.storageAreaBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    //选中的托盘
    self.selectedTrayArr = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"selectWhId:%@",self.selectWhId);
    DLog(@"selectSlId:%@",self.selectSlId);
    [self getData];
    
}

- (void)getData
{
    //1 获取库位下托盘
    [self getTrayBySlId];
    //2 获取物料状态
    [self getMaterialStatus];
    
    //3 获取辅助叉车
    [self getAssistant];
}
#pragma mark ================= 获取数据方法 =================
#pragma mark ================= 1 获取库位下的托盘 =================
-(void) getTrayBySlId
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    //NSString *whId = @"192";//仓库id
    //NSString *slId = @"30132";//库位id
    NSString *whId = self.selectWhId;//仓库id
    NSString *slId = self.selectSlId;//库位id
    DLog(@"selectWhId:%@",self.selectWhId);
    DLog(@"selectSlId:%@",self.selectSlId);
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",nil];
    if (whId) {
        [param setObject:whId forKey:@"whId"];
    }
    if (slId) {
        [param setObject:slId forKey:@"slId"];
    }
    
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
                //self.trayArr = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"data"]];
                self.trayArr = [[NSMutableArray alloc] init];
                for (int i=0; i<dataArr.count; i++) {
                    WMSTray *trayModel = [WMSTray mj_objectWithKeyValues:dataArr[i]];
                    [self.trayArr addObject:trayModel];
                }
                [self.transferCollectionView reloadData];
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

#pragma mark ================= 2 获取物料状态枚举 =================
-(void) getMaterialStatus
{
    
    [HttpTask materialStatus:nil sucessBlock:^(NSString *responseStr) {
        
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        
        if (status == 1) {
            if ([dictionary objectForKey:@"data"]) {
                self.materialStatusArr = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"data"]];
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



#pragma mark ================= 4 根据仓库获取下属库区信息 =================
-(void) getWarehouseRegion
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];
    NSString *whId = self.selectWhId;//仓库id
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId, @"whId",nil];
    [HttpTask getWarehouseRegion:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        NSArray *userInfo = [dictionary objectForKey:@"data"];
        
        if (status == 1) {
            if (userInfo.count > 0) {
                NSDictionary *whareHouseDict = [userInfo objectAtIndex:0];
                if ([whareHouseDict objectForKey:@"rrInfo"]) {
                    self.storageAreaArr = [NSMutableArray arrayWithArray:[whareHouseDict objectForKey:@"rrInfo"]];
                }
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

#pragma mark ================= 7 获取转储推荐库位列表 =================
-(void) getTransCommandLocation
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSString *whId = self.selectWhId;//仓库id
    NSString *rrId = self.selectSlId;//库区id
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",whId,@"whId",rrId,@"rrId",nil];
    DLog(@"param:%@",param);
    [HttpTask getTransCommandLocation:param sucessBlock:^(NSString *responseStr) {
        
    } failBlock:^(NSDictionary *errDict) {
        
    }];
}

#pragma mark ================= 13 获取辅助叉车 =================
-(void) getAssistant
{
    NSString *lcCode = [[WMSUser sharedUser] userLcCode];//物流中心代码
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:lcCode, @"lcCode",nil];
    DLog(@"param:%@",param);
    [HttpTask getAssistanceName:param sucessBlock:^(NSString *responseStr) {
        DLog(@"param:%@",param);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSNumber *statusNum = [dictionary objectForKey:@"success"];
        
        NSInteger status = [statusNum integerValue];
        NSString *msg = [dictionary objectForKey:@"msg"];
        
        if (status == 1) {
            if ([dictionary objectForKey:@"data"]) {
                self.assistantArr = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"data"]];
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

#pragma mark =================  自定义方法 =================
- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //[self clickButton:sender];
}

- (IBAction)panStorageChanged:(UISegmentedControl *)sender {
    
}

#pragma mark - 自定义方法 ---------------------------------------
- (IBAction)dateSelected:(UIBarButtonItem *)sender {
    self.datePicker.hidden = YES;
    self.toolbar.hidden = YES;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //这里设置输出格式
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr=[outputFormatter stringFromDate:self.datePicker.date];
    self.selectDateStr = dateStr;
    [_dateBtn setTitle:dateStr forState:UIControlStateNormal];
}
- (IBAction)showDataPicker:(UIButton *)sender {
    self.datePicker.hidden = NO;
    self.toolbar.hidden = NO;
    self.datePicker.backgroundColor = [UIColor lightGrayColor];
    self.datePicker.maximumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60];
}

//弹出popview 选择视图
- (IBAction)showDock:(UIButton *)sender {
    
    switch (sender.tag) {
        case WarehouseManageSelectRegion:
            //选择库区
            self.curSelectType = @"WarehouseManageSelectRegion";
            break;
        case WarehouseManageSelectAssistant:
            //选择叉车
            self.curSelectType = @"WarehouseManageSelectAssistant";
            break;
        case WarehouseManageSelectStatus:
            //选择状态
            self.curSelectType = @"WarehouseManageSelectStatus";
            break;
        default:
            break;
    }
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    PopViewController *popController = [board instantiateViewControllerWithIdentifier: @"PopViewController"];
    
    [popController setModalPresentationStyle:UIModalPresentationPopover];
    
    [self.navigationController presentViewController:popController animated:YES completion:nil];
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

- (NSMutableArray *)getPopviewData:(UIButton *)sender
{
    switch (sender.tag) {
        case WarehouseManageSelectRegion:
            //选择库区
            return _selectWareHouse.rrInfo;
            break;
        case WarehouseManageSelectAssistant:
            //选择叉车
            return self.assistantArr;
            break;
        case WarehouseManageSelectStatus:
            //选择状态
            return self.materialStatusArr;
            break;
        default:
            break;
    }
    return nil;
}

- (void)recordUserSelection:(WMSSelect *)sender
{
    switch (sender.selectType) {
        case WarehouseManageSelectRegion:
            //选择库区
        {
            _selectRegion = [WMSRegion mj_objectWithKeyValues:_selectWareHouse.rrInfo[sender.index]];
        }
            break;
        case WarehouseManageSelectAssistant:
            //选择叉车
        {
            _selectAssistant = [WMSAssistance mj_objectWithKeyValues:_assistantArr[sender.index]];
        }
            break;
        case WarehouseManageSelectStatus:
            //选择状态
            _selectStatus = [MaterialStatus mj_objectWithKeyValues:_materialStatusArr[sender.index]];
            break;
        default:
            break;
    }
}

//更新右侧托盘数据
- (void)updateTrayData:(WMSTray *)selectTray
{
    self.trayNumLabel.text = selectTray.trayCode;
    self.materialLabel.text = selectTray.materialName;
    self.unitNumField.text = [NSString stringWithFormat:@"%d",selectTray.quantity];
    self.minUnitField.text = [NSString stringWithFormat:@"%d",selectTray.minQuantity];
    self.unitLabel.text = selectTray.unit;
    self.minUnitLabel.text = selectTray.minUnit;
}
- (IBAction)gotoTargetStorage:(UIButton *)sender {
    
    WMSTransParam *transParam = [[WMSTransParam alloc] init];
    transParam.selectAssistantId = self.selectAssistant.userCode;
    transParam.assistantRemark = self.remarkTextView.text;
    transParam.selectDateStr = self.selectDateStr;
    //transParam.selectStatusId = [NSString stringWithFormat:@"%d",self.selectStatus.code];
    transParam.selectWhid = self.selectWhId;
    transParam.fromSSid = self.selectSlId;
    //transParam.selectRegionId = self.selectRegion.rrId;
    //transParam.materialCode = self.materialCode;
    //transParam.shipperCode = self.shipperCode;
    
    DLog(@"materialCode:%@",self.materialCode);
    
    //index == 0 转储到托盘
    //index == 1 转储到库位
    UINavigationController *detailControllrer;
    TransferTargetController *targetController;
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    if (_targetControl.selectedSegmentIndex == 0) {
        
        detailControllrer = [board instantiateViewControllerWithIdentifier: @"NavTransferTargetViewController"];
        //targetController = (TransferTargetController *)detailControllrer.topViewController;
        
    }else{
        detailControllrer = [board instantiateViewControllerWithIdentifier: @"NavTransferStorageLocationViewController"];
    }
    
    targetController = (TransferTargetController *)detailControllrer.topViewController;
    [detailControllrer setModalPresentationStyle:UIModalPresentationPageSheet];
    
    
    if (self.selectedTrayArr.count >= 1) {
        
        
        if (self.selectedTrayArr.count == 1) {
            targetController.transType = TransferTypeSingle;
            
            WMSTray *trayModel = [self.selectedTrayArr objectAtIndex:0];
            trayModel.quantity = [_unitNumField.text intValue];
            trayModel.minQuantity = [_minUnitField.text intValue];
            transParam.selelctTray = trayModel;
        }else{
            targetController.transType = TransferTypeBatch;
            
            WMSTransParam *trans = [self getShipperAndMaterial:self.selectedTrayArr];
            if (trans && trans.empty) {
                transParam.empty = YES;
            }else if(trans){
                transParam.shipperCode = trans.shipperCode;
                transParam.materialCode = trans.materialCode;
                transParam.batchNo = trans.batchNo;
                transParam.selectDateStr = transParam.pDate;
                transParam.selectStatusId = transParam.materialStatus;
            }
            transParam.selectedTrayArr = self.selectedTrayArr;
        }
        targetController.transParam = transParam;
    }else{
        [[FTYToastView alloc] addTitle:@"请选择托盘" addView:self.view];
        return;
    }
    
    [self.navigationController presentModalViewController:detailControllrer animated:YES];
}
//获取传输的参数
/*
 货主相同传货主 货主物料相同传货主物料 货主物料批次生产日期物料状态相同都传给我  货主物料都不同的 就穿empty=true
 */
- (WMSTransParam *)getShipperAndMaterial:(NSArray *)selectTrayArr
{
    
    if (selectTrayArr.count > 0) {
        WMSTransParam *transParam = [[WMSTransParam alloc] init];
        
        WMSTray *trayModel = [selectTrayArr objectAtIndex:0];
        NSString *shiperCode = trayModel.shipperCode;//货主代码
        NSString *materialCode = trayModel.materialCode;//物料代码
        NSString *batchNo = trayModel.batchNo;//批次
        NSString *pDate = trayModel.pdate;//生产日期
        NSString *materialStatus = trayModel.materialStatus;//状态
        
        int shiperId=0, materialCodeId=0, batchNoId=0, pDateId=0, materialStatusId=0;
        int count = selectTrayArr.count;
        for (int i=0; i< [selectTrayArr count]; i++) {
            WMSTray *trayModel = [selectTrayArr objectAtIndex:i];
            if (shiperCode && [shiperCode isEqualToString:trayModel.shipperCode]) {
                shiperId ++;
            }
            if (materialCode && [materialCode isEqualToString:trayModel.materialCode]) {
                materialCodeId ++;
            }
            if (batchNo && [batchNo isEqualToString:trayModel.batchNo]) {
                batchNoId ++;
            }
            if (pDate && [pDate isEqualToString:trayModel.pdate]) {
                pDateId ++;
            }
            if (materialStatus && [materialStatus isEqualToString:trayModel.materialStatus]) {
                materialStatusId ++;
            }
        }
        if (shiperId>0 || materialStatusId>0) {
            if (shiperId>0 && shiperId==count) {
                transParam.shipperCode = shiperCode;
            }
            if (materialCodeId>0 && materialCodeId==count) {
                transParam.materialCode = materialCode;
            }
            if (batchNoId>0 && batchNoId==count) {
                transParam.batchNo = batchNo;
            }
            if (materialStatusId>0 && materialStatusId==count) {
                transParam.materialStatus = materialStatus;
            }
        }else{
            transParam.empty = YES;
        }
        
        return transParam;
    }
    
    return nil;
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
    return self.trayArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PanCollectionViewCell" forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"-----------------");
    }
    
    /*
    for (NSUInteger i = 0; i< _alltimeArray.count; i++) {
        if (indexPath.row == i) {
            cell.productNum.text = _alltimeArray[i];
            cell.selectBtn.tag = indexPath.row;
            //cell.timeLabel.textColor = [UIColor redColor];
        }
    }
    */
    if (indexPath.row < self.trayArr.count) {
        
        //WMSTray *trayModel = [WMSTray mj_objectWithKeyValues:_trayArr[indexPath.row]];
        WMSTray *trayModel = [self.trayArr objectAtIndex:indexPath.row];
        DLog(@"托盘:%@",trayModel.materialCode);
        cell.panTitle.text = trayModel.trayCode;
        cell.productName.text = trayModel.materialName;
        cell.productNum.text = [NSString stringWithFormat:@"%d %@",trayModel.quantity,trayModel.unit];
        cell.productSaleUnit.text = [NSString stringWithFormat:@"%d %@",trayModel.minQuantity,trayModel.minUnit];
        cell.panRule.text = [NSString stringWithFormat:@"%d",trayModel.plateCount];
        cell.productDate.text = trayModel.pdate;
        cell.batchNum.text = trayModel.batchNo;
        cell.productStatus.text = trayModel.materialStatus;
        if (trayModel.isSelected == YES) {
             [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"box_check"] forState:UIControlStateNormal];
        }else{
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"box_uncheck"] forState:UIControlStateNormal];
        }
        /*
        if (self.selectedTrayArr.count > 0) {
            for (int i=0; i< [self.selectedTrayArr count]; i++) {
                WMSTray *selectTrayModel = [self.selectedTrayArr objectAtIndex:i];
                if ([selectTrayModel.trayCode isEqualToString:trayModel.trayCode]) {
                    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"box_check"] forState:UIControlStateNormal];
                }else{
                    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"box_uncheck"] forState:UIControlStateNormal];
                }
            }
        }else{
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"box_uncheck"] forState:UIControlStateNormal];
        }
        */
        /*
        cell.panSelected = ^(NSInteger selected){
            DLog(@"panSelected:%d",selected);
            
            trayModel.isSelected = !trayModel.isSelected;
            if (trayModel.isSelected) {
                [self updateTrayData:trayModel];//更新右侧托盘码数据
                [self.selectedTrayArr addObject:trayModel];
            }else{
                [self.selectedTrayArr removeObject:trayModel];
            }
        };
         */
         
    }
    
    switch (indexPath.row % 4) {
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


#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = self.view.frame.size.width/5.0f;
    
    return CGSizeMake(width, width);
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
    
    
    WMSTray *trayModel = [self.trayArr objectAtIndex:indexPath.row];
    trayModel.isSelected = !trayModel.isSelected;
    DLog(@"materialcode:%@",trayModel.materialCode);
    if (trayModel.isSelected) {
        [self updateTrayData:trayModel];//更新右侧托盘码数据
        [self.selectedTrayArr addObject:trayModel];
    }else{
        [self.selectedTrayArr removeObject:trayModel];
    }
    [self.transferCollectionView reloadData];
}

#pragma mark -- UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"panCell";
    PanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        //NSLog(@"如果不用registerClass则每次都不会走这里");
        //cell = [[RecipeBookCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:simpleTableIdentifier];
    }
    
        //这里是在storyboard中画的控件,在头文件中关联即可,无需在cell的init方法中初始化,直接用就行
    cell.nameLb.text = @"托盘码";
    cell.companyLb.text = @"上海益嘉物流有限公司";
    cell.boxField.text = @"10";
    cell.bottleField.text = @"50";
    
    
    return cell;
}


#pragma mark -- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
