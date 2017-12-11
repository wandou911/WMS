//
//  TransferViewController.h
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WMSStorageLocation.h"
#import "WMSTray.h"
#import "WMSSelect.h"
#import "WMSWareHouse.h"
#import "WMSRegion.h"
#import "WMSStorageLocation.h"
#import "WMSAssistance.h"
#import "MaterialStatus.h"
#import "WMSTransParam.h"

@interface TransferViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) NSArray *alltimeArray;
@property (strong, nonatomic) NSMutableArray *trayArr;//托盘数据
@property (weak, nonatomic) IBOutlet UICollectionView *transferCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *panTableView;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;//备注
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;//日期
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;//状态
@property (weak, nonatomic) IBOutlet UIButton *storageAreaBtn;//库区
@property (weak, nonatomic) IBOutlet UISegmentedControl *targetControl;
@property (weak, nonatomic) IBOutlet UILabel *OrderLabel;//盘点单号
@property (weak, nonatomic) IBOutlet UILabel *trayNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;

@property (weak, nonatomic) IBOutlet UITextField *unitNumField;//主数量
@property (weak, nonatomic) IBOutlet UITextField *minUnitField;//辅助数量
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;//基本单位
@property (weak, nonatomic) IBOutlet UILabel *minUnitLabel;//辅助单位
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

//从上个页面传入的参数
@property (strong, nonatomic) WMSWareHouse *selectWareHouse;//选中的仓库
@property (strong, nonatomic) NSString *selectWhId;//选中的仓库id
@property (strong, nonatomic) NSString *selectSlId;//选中的库位id
@property (strong, nonatomic) NSString *shipperCode;//选择的货主
@property (strong, nonatomic) NSString *materialCode;//选择的物料

//popview结果数据
@property (strong, nonatomic) WMSRegion *selectRegion;//popview选择的库区
@property (strong, nonatomic) WMSAssistance *selectAssistant;//popview选择的叉车
@property (strong, nonatomic) MaterialStatus *selectStatus;//popview选择状态
@property (strong, nonatomic) NSMutableArray *selectedTrayArr;//选中的托盘
@property (strong, nonatomic) NSString *selectDateStr;//选择的日期
@property (strong, nonatomic) NSString *transOderNum;//盘点单号
@property (strong, nonatomic) NSString *curSelectType;

//列表数据
@property (strong, nonatomic) NSMutableArray *materialStatusArr;//物料状态数据
@property (strong, nonatomic) NSMutableArray *storageAreaArr;//库区数据
@property (strong, nonatomic) NSMutableArray *assistantArr;//辅助叉车工数据




@end
