//
//  UnSignClinicCell.m
//  CRM
//
//  Created by Argo Zhang on 15/11/12.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "UnSignClinicCell.h"
#import "UnSignClinicModel.h"
#import "UIImageView+WebCache.h"

@interface UnSignClinicCell (){
    UIImageView *_iconView;//诊所头像
    UILabel *_clinicName; //诊所名称
    UILabel *_clinicAddress;//诊所地址
}

#define ClinicNameFont [UIFont boldSystemFontOfSize:14]
#define ClinicAddressFont [UIFont systemFontOfSize:12]
#define Margin 5
#define IconWidth 50
#define IconHeight IconWidth

@end

@implementation UnSignClinicCell

#pragma mark -类方法创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"unsignclinic_cell";
    UnSignClinicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark -初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //初始化方法
        [self setUpSubViews];
    }
    return self;
}

#pragma mark 初始化子控件
- (void)setUpSubViews{
    //创建诊所头像
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    
    //创建诊所名称
    _clinicName = [[UILabel alloc] init];
    _clinicName.textColor = [UIColor blackColor];
    _clinicName.font = ClinicNameFont;
    [self.contentView addSubview:_clinicName];
    
    //创建诊所地址
    _clinicAddress = [[UILabel alloc] init];
    _clinicAddress.textColor = [UIColor lightGrayColor];
    _clinicAddress.font = ClinicAddressFont;
    _clinicAddress.numberOfLines = 0;
    [self.contentView addSubview:_clinicAddress];
    
}

#pragma mark -设置子控件的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //诊所头像
    _iconView.frame = CGRectMake(Margin * 2, Margin * 2, IconWidth, IconHeight);
    
    //诊所名称
    NSString *clinicName = self.model.clinic_name;
    CGSize clinicNameSize = [clinicName sizeWithFont:ClinicNameFont];
    _clinicName.frame = CGRectMake(CGRectGetMaxX(_iconView.frame) + Margin * 2, Margin * 2, clinicNameSize.width, clinicNameSize.height);
    
    //诊所地址
    NSString *clinicAddress = self.model.clinic_location;
    CGSize clinicAddressSize =[clinicAddress sizeWithFont:ClinicAddressFont constrainedToSize:CGSizeMake(kScreenWidth - CGRectGetMaxX(_iconView.frame) - Margin * 5, MAXFLOAT)];
    _clinicAddress.frame = CGRectMake(CGRectGetMaxX(_iconView.frame) + Margin * 2, CGRectGetMaxY(_clinicName.frame) + Margin, clinicAddressSize.width, clinicAddressSize.height);

}

- (void)setModel:(UnSignClinicModel *)model{
    
    _model = model;
    
    //给控件赋值
    if(self.model.clinic_img){
        NSURL *imageUrl = [NSURL URLWithString:self.model.clinic_img];
        [_iconView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"doctor_headimage.png"]];
    }
    
    _clinicName.text = self.model.clinic_name;
    
    _clinicAddress.text = self.model.clinic_location;
}


@end
