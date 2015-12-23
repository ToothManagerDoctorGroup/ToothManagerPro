//
//  AppointmentTableViewCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AppointmentTableViewCell.h"

@interface AppointmentTableViewCell (){
    UILabel *_contentLabel;
    UIView *_lineView;
}

@end

@implementation AppointmentTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"tableView_cell";
    AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_contentLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)setTime:(NSString *)time{
    _time = time;
    
    _contentLabel.frame = CGRectMake(0, 0, 60, 60);
    _contentLabel.text = time;
    
    _lineView.frame = CGRectMake(0, 60, 60, 1);
}

@end
