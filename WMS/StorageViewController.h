//
//  StorageViewController.h
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WMSWareHouse.h"
#import "WMSRegion.h"
#import "WMSShipper.h"
#import "WMSMaterial.h"
#import "WMSStorageLocation.h"


@interface StorageViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSArray *alltimeArray;
@property (weak, nonatomic) IBOutlet UICollectionView *storageCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *wareHouseBtn;
@property (weak, nonatomic) IBOutlet UIButton *regionBtn;
@property (weak, nonatomic) IBOutlet UIButton *shipperBtn;
@property (weak, nonatomic) IBOutlet UIButton *materialBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextField *shipperField;
@property (weak, nonatomic) IBOutlet UITextField *materialField;

@property (nonatomic, strong) NSMutableArray *warehouseAndRegionArr;//仓库及下属库区
@property (nonatomic, strong) NSMutableArray *customerArr;//货主
@property (nonatomic, strong) NSMutableArray *materialArr;//物料
@property (nonatomic, strong) NSMutableArray *storageLocationArr;//库位

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, strong) NSString *curSelectType;//当前选择类型
@property (nonatomic, strong) NSString *searchText;

@property (nonatomic, strong) WMSWareHouse *selectWareHouse;//选择的仓库
@property (nonatomic, strong) WMSRegion *selectRegion;//选择的库区
@property (nonatomic, strong) WMSShipper *selectShipper;//选择的货主
@property (nonatomic, strong) WMSMaterial *selectWMSMaterial;//选择的物料
@property (nonatomic, strong) WMSStorageLocation *selectStorage;//选中的库位
@property (nonatomic, assign) NSInteger shipperTotalNum;//货主总数
@property (nonatomic, assign) NSInteger materialTotalNum;//物料总数
@property (nonatomic, assign) ViewType pageControllView;//只做展示
@property (nonatomic, assign) float ratio;//缩放比例




@end
