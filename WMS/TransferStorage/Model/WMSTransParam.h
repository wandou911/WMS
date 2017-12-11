//
//  WMSTransParam.h
//  WMS
//
//  Created by wandou on 17/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSTray.h"

@interface WMSTransParam : NSObject

@property (strong, nonatomic) NSString *selectWhid;//选择的仓库id
@property (strong, nonatomic) NSString *fromSSid;//库位id
@property (strong, nonatomic) NSString *selectRegionId;//popview选择的库区
@property (strong, nonatomic) NSString *selectAssistantId;//popviev选择的叉车
@property (strong, nonatomic) NSString *assistantRemark;//叉车工备注
@property (strong, nonatomic) NSString *selectStatusId;//popview选择状态
@property (strong, nonatomic) NSMutableArray *selectedTrayArr;//选中的托盘arr,批量转储
@property (strong, nonatomic) WMSTray *selelctTray;//选择的托盘，单个托盘到托盘转储
@property (strong, nonatomic) NSString *selectDateStr;//选择的日期
@property (strong, nonatomic) NSString *shipperCode;//货主代码
@property (strong, nonatomic) NSString *materialCode;//物料代码
@property (strong, nonatomic) NSString *batchNo;//批次
@property (strong, nonatomic) NSString *materialStatus;//物料状态
@property (strong, nonatomic) NSString *pDate;//生产日期
@property (assign, nonatomic) BOOL empty;//是否空库位
@property (strong, nonatomic) NSString *curSelectType;


@end
