//
//  IntroducerTableViewCell.h
//  CRM
//
//  Created by TimTiger on 6/1/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimFramework.h"

@interface IntroducerTableViewCell : UITableViewCell

@property (nonatomic,readonly) UILabel *nameLabel;
@property (nonatomic,readonly) UILabel *countLabel;
@property (nonatomic,readonly) TimStarView *starView;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,readwrite) NSInteger count;
@property (nonatomic,readwrite) CGFloat level; // 1~5

@end
