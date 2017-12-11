//
//  WMSShipper.h
//  WMS
//
//  Created by wandou on 09/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSSelect.h"

@interface WMSShipper : WMSSelect

@property (nonatomic, assign) BOOL isGroup;//是否为集团货主
@property (nonatomic, strong) NSString *name;//货主名称
@property (nonatomic, strong) NSString *code;//库区类型代码

@end
