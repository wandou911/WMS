//
//  WMSWareHourse.h
//  WMS
//
//  Created by wandou on 2017/11/7.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSSelect.h"

@interface WMSWareHouse : WMSSelect

@property (nonatomic, strong) NSString *whId;//仓库ID
@property (nonatomic, strong) NSString *name;//仓库名
@property (nonatomic, strong) NSMutableArray *rrInfo;//下属库区
@property (nonatomic, assign) float width;//仓库长度 x轴方向
@property (nonatomic, assign) float length;//仓库长度 y轴方向

@end
