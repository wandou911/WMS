//
//  TransferTargetController.h 目标托盘
//  WMS
//
//  Created by wandou on 2017/8/31.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WMSTray.h"
#import "WMSStorageLocation.h"
#import "WMSTransParam.h"

@interface TransferTargetController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UICollectionView *storageCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *panCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) NSMutableArray *commendLocationArr;
@property (nonatomic, strong) NSMutableArray *panArr;

//传入参数
@property (nonatomic, strong) WMSTransParam *transParam;
@property (nonatomic, strong) NSMutableArray *selectPanArr;//选择要转储的托盘
@property (nonatomic, assign) TransferType transType;//转储类型
@property (nonatomic, strong) NSString *selectedWhid;//选择的仓库id
@property (nonatomic, strong) NSString *selectedSlId;//选择的库位id
@property (nonatomic, strong) NSString *oderId;//盘点单号

@property (nonatomic, strong) WMSStorageLocation *targetLocation;//目标库位
@property (nonatomic, assign) NSInteger selectLocationIndex;
@property (nonatomic, assign) NSInteger selectPanIndex;



@end
