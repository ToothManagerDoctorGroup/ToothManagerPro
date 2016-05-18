//
//  CommentModelFrame.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "CommentModelFrame.h"
#import "CommentModel.h"


#define CommenTitleColor MyColor(69, 69, 70)
#define DoctorNameFont [UIFont systemFontOfSize:14]
#define SendTimeFont [UIFont systemFontOfSize:12]
#define ContentFont [UIFont systemFontOfSize:16]

@implementation CommentModelFrame

- (void)setModel:(PatientConsultation *)model{
    _model = model;
    
    
    //计算头像的frame
    CGFloat headW = 50;
    CGFloat headH = 50;
    CGFloat Margin = 5;
    _headImgFrame = CGRectMake(Margin, Margin, headW, headH);
    
    //计算姓名的frame
    CGFloat docNameX = CGRectGetMaxX(_headImgFrame) + Margin;
    CGFloat docNameY = Margin * 2;
    CGSize doctorSize = [model.doctor_name sizeWithFont:DoctorNameFont];
    _nameFrame = CGRectMake(docNameX, docNameY, doctorSize.width, doctorSize.height);
    
    //计算时间frame
    CGSize timeSize = [model.creation_date sizeWithFont:SendTimeFont];
    CGFloat timeX = kScreenWidth - timeSize.width - Margin;
    CGFloat timeY = docNameY;
    _timeFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    //计算内容的frame
    CGFloat contentX = docNameX;
    CGFloat contentY = CGRectGetMaxY(_nameFrame) + Margin * 1.5;
    CGSize contentSize = [model.cons_content sizeWithFont:ContentFont constrainedToSize:CGSizeMake(kScreenWidth - Margin * 3 - _headImgFrame.size.width, MAXFLOAT)];
    _contentFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    
    //计算cell的高度
    _cellHeight = CGRectGetMaxY(_contentFrame) + Margin;
}

@end
