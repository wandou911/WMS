//
//  MaterialStatus.h
//  WMS
//
//  Created by wandou on 14/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialStatus : NSObject

@property (nonatomic, assign) int code;//物料张贴码
@property (nonatomic, strong) NSString *des;//物料状态描述
@property (nonatomic, strong) NSString *name;//物料状态名称

@end
