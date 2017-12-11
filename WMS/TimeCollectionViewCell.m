//
//  TimeCollectionViewCell.m
//  CollectionViewTest
//
//  Created by wandou on 2017/8/21.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "TimeCollectionViewCell.h"
#import "FTYColor.h"

@implementation TimeCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor grayColor];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        //self.timeLabel.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.timeLabel];
        
        //self.backgroundColor = [FTYColor getColor:@"f7fcff" andAlpha:1.0f];
        self.layer.borderColor = [FTYColor getColor:@"ebecec" andAlpha:1.0f].CGColor;
        self.layer.borderWidth = 1.0;
    }
    
    return self;
}

@end
