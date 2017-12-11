//
//  WMSRegion.h
//  WMS
//
//  Created by wandou on 09/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSSelect.h"

@interface WMSRegion : WMSSelect

@property (nonatomic, strong) NSString *rrName;//库区名称
@property (nonatomic, strong) NSString *rrId;//库区ID
@property (nonatomic, strong) NSString *code;//库区类型代码
@property (nonatomic, strong) NSString *type;//库区类型



@end
