//
//  TransferLocationViewController.h
//  WMS
//
//  Created by wandou on 05/12/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WMSTransParam.h"
#import "WMSStorageLocation.h"

@interface TransferLocationViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *storageLocationArr;//库位
@property (nonatomic, strong) WMSStorageLocation *targetLocation;//目标库位
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, strong) UIView *btnBgView;
@property (nonatomic, assign) float ratio;//缩放比例wareHouseHeight
@property (nonatomic, assign) float wareHouseHeight;
@property (nonatomic, assign) float wareHouseWidth;
//传入参数
@property (nonatomic, strong) WMSTransParam *transParam;
@property (nonatomic, strong) NSMutableArray *selectPanArr;//选择要转储的托盘
@property (nonatomic, assign) TransferType transType;//转储类型
@property (nonatomic, strong) NSString *selectedWhid;//选择的仓库id
@property (nonatomic, strong) NSString *selectedSlId;//选择的库位id
@property (nonatomic, strong) NSString *oderId;//盘点单号

@end
