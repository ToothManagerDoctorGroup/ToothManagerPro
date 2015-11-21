//
//  DropDownView.h
//  CRM
//
//  Created by mac on 14-5-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownView : UIView<UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *tableView;//下拉列表
    NSArray *tableArray;//下拉列表数据
    UILabel *textField;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    
    UIButton *selectButton;
    NSInteger resultIndex;
}

@property (nonatomic,retain) UITableView * mytableView;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UILabel *textField;
@property (nonatomic,assign) NSInteger resultIndex;

-(void)hidden;
@end
