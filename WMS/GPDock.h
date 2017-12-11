//
//  GPDock.h
//  WMS
//
//  Created by wandou on 2017/8/25.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPTabItem.h"

@class GPDock;
@protocol GPDockItemDelegate <NSObject>

-(void)switchMainByTabItem:(GPDock*)gpdock originalTab:(int)start destinationTab:(int)end;

@end


@interface GPDock : UIView
{
    GPTabItem *selectedTabItem;
}

@property (nonatomic,weak) id<GPDockItemDelegate> dockDelegate;

@end
