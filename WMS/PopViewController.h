//
//  PopViewController.h
//  WMS
//
//  Created by wandou on 2017/8/30.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMSSelect.h"

typedef void(^Blo)(WMSSelect *selectModel);

@interface PopViewController : UITableViewController


@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) Blo block;
@property (nonatomic, strong) NSString *curType;
@property (nonatomic, strong) NSString *searchText;

@end
