//
//  HttpTask.h
//  WMS
//
//  Created by wandou on 2017/11/6.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTask : NSObject

#pragma mark ================= 登陆 =================
+(void) login:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;


#pragma mark ================= 库位管理接口 =================

#pragma mark ================= 获取仓库及下属库区信息 =================
+(void) getWarehouseRegion:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;

#pragma mark ================= 获取库位信息 =================
+(void) getSlInfo:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;

#pragma mark ================= 分页获取物流中心下货主 =================
+(void) getCustomer:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
#pragma mark ================= 分页物料查询 =================
+(void) getMaterial:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;







#pragma mark ================= 转储接口 =================
#pragma mark ================= 获取库位下的托盘 =================
+(void) getTrayBySlId:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
#pragma mark ================= 创建无单转储 =================
+(void) createNoOrderTransfer:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;

#pragma mark ================= 获取转储推荐库位列表 =================
+(void) getTransCommandLocation:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
#pragma mark ================= 批量无单转储 =================
+(void) batchTransNoOrder:(NSDictionary *) param
                  sucessBlock:(void (^)(NSString *))sucessCallback
                    failBlock:(void (^)(NSDictionary *))failCallback;

#pragma mark ================= 无单转储删除 =================
+(void) deleteTransOrder:(NSDictionary *) param
                    sucessBlock:(void (^)(NSString *))sucessCallback
                      failBlock:(void (^)(NSDictionary *))failCallback;

#pragma mark ================= 判断是否可转储 =================
+(void) judgeTrayTransfer:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
#pragma mark ================= 转储单处理 =================
+(void) submitTransOperate:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;



#pragma mark ================= 获取物料状态枚举 =================
+(void) materialStatus:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
#pragma mark ================= 获取辅助叉车 =================
+(void) getAssistanceName:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
#pragma mark ================= 登陆 =================
+(void) login:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
#pragma mark ================= 登陆 =================
+(void) login:(NSDictionary *) param
  sucessBlock:(void (^)(NSString *))sucessCallback
    failBlock:(void (^)(NSDictionary *))failCallback;
@end
