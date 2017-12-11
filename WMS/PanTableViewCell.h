//
//  PanTableViewCell.h
//  WMS
//
//  Created by wandou on 2017/8/23.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet UITextField *boxField;
@property (weak, nonatomic) IBOutlet UITextField *bottleField;

@end
