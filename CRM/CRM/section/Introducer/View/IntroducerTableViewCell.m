//
//  IntroducerTableViewCell.m
//  CRM
//
//  Created by TimTiger on 6/1/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "IntroducerTableViewCell.h"

@implementation IntroducerTableViewCell
@synthesize level = _level;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

static void setLastCellSeperatorToLeft(UITableViewCell* cell)
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)setupView {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_nameLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.font = [UIFont systemFontOfSize:16.0f];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_countLabel];
    
    _starView = [[TimStarView alloc] init];
    [self.contentView addSubview:_starView];
}

- (void)setName:(NSString *)name {
    _nameLabel.text = name;
}

-(NSString *)name {
    return _nameLabel.text;
}

- (void)setLevel:(CGFloat)level {
    _level = level;
    self.starView.scale = level;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    _countLabel.text = [NSString stringWithFormat:@"%d人",(int)_count];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat commonW = kScreenWidth / 3;
    
    _nameLabel.frame = CGRectMake(0, 0, commonW, self.bounds.size.height);
    _countLabel.frame = CGRectMake(_nameLabel.right,0, commonW, self.bounds.size.height);
    
    CGFloat starW = 75;
    CGFloat starH = 14;
    CGFloat starX = _countLabel.right + (commonW - starW) / 2;
    CGFloat starY = (self.height - starH) / 2;
    _starView.frame = CGRectMake(starX,starY,starW,starH);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
