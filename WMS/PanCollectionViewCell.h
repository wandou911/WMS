//
//  PanCollectionViewCell.h
//  目标托盘选中托盘
//  WMS
//
//  Created by wandou on 2017/8/31.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PanSelect)(NSInteger selectPanNum);

@interface PanCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *panTitle;//托盘码
@property (weak, nonatomic) IBOutlet UILabel *productName;//物料名称
@property (weak, nonatomic) IBOutlet UILabel *productNum;// 基本数量
@property (weak, nonatomic) IBOutlet UILabel *productSaleUnit;//最小销售单位
@property (weak, nonatomic) IBOutlet UILabel *panRule;//码盘规则
@property (weak, nonatomic) IBOutlet UILabel *productDate;//生产日期
@property (weak, nonatomic) IBOutlet UILabel *batchNum;//批次
@property (weak, nonatomic) IBOutlet UILabel *productStatus;//状态
@property (nonatomic, copy) PanSelect panSelected;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
