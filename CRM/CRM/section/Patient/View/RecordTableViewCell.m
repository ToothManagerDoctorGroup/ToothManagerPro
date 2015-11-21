//
//  RecordTableViewCell.m
//  CRM
//
//  Created by TimTiger on 2/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "DBTableMode.h"

@interface RecordTableViewCell ()
@property (nonatomic,retain) UIImageView *headerView;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UIImageView *contentImageView;
@property (nonatomic,retain) UILabel *contentLabel;
@end

@implementation RecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 40, 40)];
        _headerView.image = [UIImage imageNamed:@"header_defult.png"];
        _headerView.clipsToBounds = YES;
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.layer.cornerRadius = 20.f;
        _headerView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _headerView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:_headerView];
        
        UIImage *image = [[UIImage imageNamed:@"record_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        _contentImageView = [[UIImageView alloc]initWithImage:image];
        _contentImageView.frame = CGRectMake(_headerView.frame.origin.x+_headerView.bounds.size.width+18, 0, 30, 30);
        [self.contentView addSubview:_contentImageView];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_contentImageView.frame.origin.x+5,5, 175, 30)];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.textColor = [UIColor viewFlipsideBackgroundColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 50, 10)];
        _nameLabel.font = [UIFont systemFontOfSize:11.0f];
        _nameLabel.textColor = [UIColor viewFlipsideBackgroundColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

-(void)setCellWithRecord:(MedicalRecord *)record size:(CGSize)size {
    CGRect frame = self.contentLabel.frame;
    frame.size = CGSizeMake(size.width, size.height);
    self.contentLabel.frame = frame;
    frame = self.contentImageView.frame;
    frame.size = CGSizeMake(size.width+10, size.height+10);
    self.contentImageView.frame = frame;
    self.contentLabel.text = record.record_content;
}

-(void)setCellWithPatientC:(PatientConsultation *)patientC size:(CGSize)size {
    CGRect frame = self.contentLabel.frame;
    frame.size = CGSizeMake(size.width, size.height);
    self.contentLabel.frame = frame;
    frame = self.contentImageView.frame;
    frame.size = CGSizeMake(size.width+10, size.height+10);
    self.contentImageView.frame = frame;
    self.contentLabel.text = patientC.cons_content;
    self.nameLabel.text = patientC.doctor_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
