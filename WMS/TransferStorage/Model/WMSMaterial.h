//
//  WMSMaterial.h
//  WMS
//
//  Created by wandou on 09/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSSelect.h"

@interface WMSMaterial : WMSSelect

@property (nonatomic, assign) int spec;//规格
@property (nonatomic, strong) NSString *minUnit;//最小单位
@property (nonatomic, strong) NSString *name;//物料名称
@property (nonatomic, strong) NSString *code;//物料代码
@property (nonatomic, strong) NSString *commonUnit;//常用单位
@property (nonatomic, strong) NSString *batchAttribute;//批次属性


@end
