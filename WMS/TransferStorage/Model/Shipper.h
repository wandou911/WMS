//
//  Shipper.h
//  WMS
//
//  Created by wandou on 09/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shipper : NSObject

@property (nonatomic, strong) BOOL isGroup;//
@property (nonatomic, strong) NSString *rrId;//库区ID
@property (nonatomic, strong) NSString *code;//库区类型代码

@end
