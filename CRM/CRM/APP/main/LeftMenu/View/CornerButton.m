//
//  CornerButton.m
//  RuiliVideo
//
//  Created by TimTiger on 14-7-28.
//  Copyright (c) 2014年 Mudmen. All rights reserved.
//

#import "CornerButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Extension.h"

@implementation CornerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
}

@end
