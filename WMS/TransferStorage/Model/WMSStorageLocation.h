//
//  WMSStorageLocation.h
//  WMS
//
//  Created by wandou on 13/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMSStorageLocation : NSObject

@property (nonatomic, assign) int capacity;//库位容积
@property (nonatomic, assign) int length;//库位长度
@property (nonatomic, strong) NSString *name;//库位名
@property (nonatomic, assign) int realCapacity;//库位实际占用量
@property (nonatomic, assign) int serial;//库位顺序号
@property (nonatomic, strong) NSString *status;//库位状态 有效 
@property (nonatomic, assign) int width;//库位宽度
@property (nonatomic, assign) int xaxis;//库位x坐标
@property (nonatomic, assign) int yaxis;//库位y坐标
@property (nonatomic, assign) long slId;//库位id
@property (nonatomic, assign) BOOL isSelected;//是否选中
@property (nonatomic, strong) NSString *num;



@end
