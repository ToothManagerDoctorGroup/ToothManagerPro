//
//  TSPopoverTouchView.m
//
//  Created by Saito Takashi on 5/9/12.
//  Copyright (c) 2012 synetics ltd. All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import "TSPopoverTouchView.h"

@implementation TSPopoverTouchView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.75];
//        self.alpha = 0.5;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate view:self touchesBegan:touches withEvent:event];
}

@end
