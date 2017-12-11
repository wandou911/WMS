//
//  WMSTray.h 托盘
//  WMS
//
//  Created by wandou on 13/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMSTray : NSObject

@property (nonatomic, strong) NSString *materialCode;//物料代码
@property (nonatomic, strong) NSString *materialName;//物料名
@property (nonatomic, assign) int minQuantity;//最小单位数量
@property (nonatomic, assign) int quantity;//常用单位数量
@property (nonatomic, strong) NSString *minUnit;//最小单位
@property (nonatomic, strong) NSString *unit;//常用单位
@property (nonatomic, strong) NSString *shipperCode;//货主代码
@property (nonatomic, strong) NSString *shipperName;//货主名
@property (nonatomic, strong) NSString *qt;//质检状态
@property (nonatomic, strong) NSString *trayCode;//托盘码
@property (nonatomic, strong) NSString *batchNo;//批次
@property (nonatomic, strong) NSString *pdate;//生产日期
@property (nonatomic, strong) NSString *inDate;//生产日期
@property (nonatomic, strong) NSString *materialStatus;//物料状态
@property (nonatomic, assign) int materialStatusCode;//物料状态码
@property (nonatomic, assign) int plateCount;//码盘规则
@property (nonatomic, assign) BOOL isSelected;//是否被选择

@end
