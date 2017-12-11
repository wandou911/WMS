//
//  WMSSelect.h
//  WMS
//
//  Created by wandou on 09/11/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMSSelect : NSObject

@property (nonatomic, strong) NSString *title;//名称
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger selectType;//当前选择类型
@property (nonatomic, assign) BOOL isCheck;

@end
