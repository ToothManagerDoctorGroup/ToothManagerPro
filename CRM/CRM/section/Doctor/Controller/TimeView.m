//
//  TimeView.m
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kCount 20
#import "TimeView.h"
#import "MyLabel.h"
#import "TimeCell.h"
@interface TimeView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *times;
@end

@implementation TimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
//        for(int i=0;i<20;i++){
// 
//            MyLabel *timeLabel=[[MyLabel alloc]initWithFrame:CGRectMake(0, i*(kHeight+kHeightMargin), kWidth, (kHeight+kHeightMargin))];
////            timeLabel.backgroundColor=[UIColor yellowColor];
//            [timeLabel setVerticalAlignment:VerticalAlignmentTop];
//            timeLabel.textAlignment=NSTextAlignmentRight;
//            int currentTime=i*30+510;
//            timeLabel.text=[NSString stringWithFormat:@"%d:%02d",currentTime/60,currentTime%60];
//            [self addSubview:timeLabel];
//        
//        }
        self.times=[NSMutableArray array];
        for (int i=0; i<=kCount; i++) {
            int currentTime=i*30+510;
            NSString *time=[NSString stringWithFormat:@"%d:%02d",currentTime/60,currentTime%60];
            [self.times addObject:time];
        }
        
         self.timeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
         self.timeTableView.delegate=self;
         self.timeTableView.dataSource=self;
         self.timeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
         self.timeTableView.userInteractionEnabled=NO;
        [self addSubview: self.timeTableView];
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    TimeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        
        cell=[[TimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.timeLabel.text=self.times[indexPath.row];
    return cell;
}
@end
