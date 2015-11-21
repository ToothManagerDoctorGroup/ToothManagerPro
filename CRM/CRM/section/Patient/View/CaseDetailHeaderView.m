//
//  CaseDetailHeaderView.m
//  CRM
//
//  Created by TimTiger on 6/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CaseDetailHeaderView.h"

@implementation CaseDetailHeaderView

- (void)awakeFromNib
{
    // Initialization code
    [self.ctScrollView setPagingEnabled:YES];
    self.ctScrollView.layer.cornerRadius = 3.0f;
    self.ctScrollView.clipsToBounds = YES;
}

- (void)setCtImageArray:(NSArray *)ctImageArray {
    _ctImageArray = ctImageArray;
    NSInteger i = 0;
    for (UIImage *image in _ctImageArray) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.ctScrollView.bounds.size.width*i, 0, self.ctScrollView.bounds.size.width, self.ctScrollView.bounds.size.height)];
        [imageView setImage:image];
        imageView.tag = 100+i;
        i++;
        [self.ctScrollView addSubview:imageView];
    }
    self.ctScrollView.contentSize = CGSizeMake(_ctImageArray.count*self.ctScrollView.bounds.size.width+1, self.ctScrollView.bounds.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
