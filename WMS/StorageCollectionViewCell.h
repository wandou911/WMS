//
//  StorageCollectionViewCell.h
//  目标托盘推荐库位
//  WMS
//
//  Created by wandou on 2017/8/31.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMSSelect.h"

typedef void(^StorageSelect)(WMSSelect *selectPanNum);

@interface StorageCollectionViewCell : UICollectionViewCell
//@property (nonatomic, copy) StorageSelect storageSelected;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLb;
@property (weak, nonatomic) IBOutlet UILabel *capacityLb;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
