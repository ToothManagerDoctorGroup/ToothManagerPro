//
//  XLStarView.m
//  CRM
//
//  Created by Argo Zhang on 16/2/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLStarView.h"
#import "TimStarView.h"
#import "UIView+WXViewController.h"

@interface XLStarView ()

@property (nonatomic, strong)TimStarView *starView;

@end

@implementation XLStarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)awakeFromNib{
    //初始化
    [self setUp];
}

- (void)setUp{
    if (self.starView == nil) {
        self.starView = [[TimStarView alloc] init];
        self.starView.userInteractionEnabled = NO;
        self.alignment = XLStarViewAlignmentCentre;
        [self addSubview:self.starView];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.alignment == XLStarViewAlignmentCentre) {
        self.starView.frame = CGRectMake((self.bounds.size.width - 75) / 2, (self.bounds.size.height - 15) / 2, 75, 15);
    }else if (self.alignment == XLStarViewAlignmentLeft){
        self.starView.frame = CGRectMake(0, (self.bounds.size.height - 15) / 2, 75, 15);
    }else{
        self.starView.frame = CGRectMake(self.bounds.size.width - 75, (self.bounds.size.height - 15) / 2, 75, 15);
    }
    
    self.starView.scale = self.level;
}

- (void)setLevel:(NSInteger)level{
    _level = level;
    
     self.starView.scale = self.level;
}

- (void)setAlignment:(XLStarViewAlignment)alignment{
    _alignment = alignment;
    
    [self setNeedsLayout];
}
@end
