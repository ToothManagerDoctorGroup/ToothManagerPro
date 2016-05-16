//
//  MyCell.m
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//


#import "MyCell.h"
#import "HeadView.h"
#import "MeetModel.h"
@interface MyCell()<HeadViewDelegate>

@end

@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for(int i=0;i<20;i++){
        
            HeadView *headView=[[HeadView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth-kWidthMargin, kHeight+kHeightMargin)];
            headView.delegate=self;
            headView.backgroundColor=[UIColor whiteColor];
            [self.contentView addSubview:headView];
        }
        
    }
    return self;
}
-(void)headView:(HeadView *)headView point:(CGPoint)point
{
    if([self.delegate respondsToSelector:@selector(myHeadView:point:)]){
    
        [self.delegate myHeadView:headView point:point];
    }

}
-(void)setCurrentTime:(NSMutableArray *)currentTime
{
     _currentTime=currentTime;
    int count=currentTime.count;
    if(count>0){
        for(int i=0;i<count;i++){
        
            MeetModel *model=currentTime[i];
            
            HeadView *headView;
            if([model.meetRoom isEqualToString:@"000"]){
              
                headView=(HeadView *)self.contentView.subviews[0];
            }else{
               
                NSArray *room=[model.meetRoom componentsSeparatedByString:@"0"];
                headView=(HeadView *)self.contentView.subviews[[[room lastObject] intValue]];
            }
            headView.backgroundColor=[UIColor greenColor];
            
            for(HeadView *leftHeadView in self.contentView.subviews){
              
                if(headView!=leftHeadView) leftHeadView.backgroundColor=[UIColor grayColor];
            }
        }
    }else{
       
        for(HeadView *headView in self.contentView.subviews){
        
            headView.backgroundColor=[UIColor whiteColor];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
