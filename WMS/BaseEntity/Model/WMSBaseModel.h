//
//  WMSBaseModel.h
//  WMS
//
//  Created by wandou on 2017/11/7.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMSBaseModel : NSObject

@property (nonatomic, copy) NSDictionary *err;
@property (nonatomic, copy) NSDictionary *info;

@end



@interface WMSErrorInfoModel : NSObject

@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, copy) NSString *errorinfo;

@end


