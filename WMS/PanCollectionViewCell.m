//
//  PanCollectionViewCell.m
//  WMS
//
//  Created by wandou on 2017/8/31.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "PanCollectionViewCell.h"

@implementation PanCollectionViewCell

- (IBAction)selectPan:(UIButton *)sender {
    
     sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"box_check"] forState:UIControlStateNormal];
        
        
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"box_uncheck"] forState:UIControlStateNormal];
        
    }
   
    
    self.panSelected(sender.tag);
    
    
}

@end
