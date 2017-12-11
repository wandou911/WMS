//
//  StorageCollectionViewCell.m
//  WMS
//
//  Created by wandou on 2017/8/31.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "StorageCollectionViewCell.h"
#import "WMSStorageLocation.h"

@implementation StorageCollectionViewCell

- (IBAction)selectStorage:(UIButton *)sender {
    
    WMSSelect *selection = [[WMSSelect alloc] init];
    selection.index = sender.tag;
    
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"radio_check"] forState:UIControlStateNormal];
        selection.isCheck = YES;
        
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"radio_uncheck"] forState:UIControlStateNormal];
        selection.isCheck = NO;
    }
    
    //self.storageSelected(selection);
}

- (IBAction)selectLocation:(WMSStorageLocation *)sender
{
    
}
@end
