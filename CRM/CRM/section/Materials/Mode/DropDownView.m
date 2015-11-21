//
//  DropDownView.m
//  CRM
//
//  Created by mac on 14-5-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "DropDownView.h"
#import "CommonMacro.h"

@implementation DropDownView

@synthesize mytableView,tableArray,textField,resultIndex;

- (id)initWithFrame:(CGRect)frame
{
    /*frameHeight:上面lable和下面table的整个高度
     *tabheight:下面table的高度
     */
    frameHeight = frame.size.height;
    tabheight = frameHeight-30;
    frame.size.height = 30.0f;
    self=[super initWithFrame:frame];
    if(self){
        showList = NO; //默认不显示下拉框
        
        //测试数组
//        self.tableArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"1",@"2",@"3",@"4",@"5", nil];
        if (tableArray != nil && [tableArray count] > 0){
            NSLog(@"tableArray:%@",tableArray);
        }
        
        textField = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [self addSubview:textField];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, textField.frame.size.height + textField.frame.origin.y, frame.size.width, 200)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.hidden = YES;
        //去掉多余的cell
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:tableView];
        
        selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setImage:[UIImage imageNamed:@"select_down.png"] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(dropdown:) forControlEvents:UIControlEventTouchUpInside];
        if (IOS_7_OR_LATER) {
            selectButton.frame=CGRectMake(frame.size.width-30, 1, 35, 29);
        } else {
            selectButton.frame=CGRectMake(frame.size.width-30, 2, 35, 26);
        }
        [self addSubview:selectButton];
    }
    return self;
}

//下拉
-(IBAction)dropdown:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    selectButton = btn;
    [btn removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"select_up.png"] forState:UIControlStateNormal];
    
    CGRect frame = self.frame;
    frame.size.height = frameHeight;
    if (tableArray.count<=1) {
        frame.size.height = 35+20+30;
    } else {
        frame.size.height = frameHeight;
    }
    self.frame = frame;
    
    tableView.hidden = NO;
    
    CGRect tableViewFrame = tableView.frame;
    tableViewFrame.size.height = tabheight;
    if (tableArray.count<=1) {
        tableViewFrame.size.height = 35+20;
    } else {
        tableViewFrame.size.height = tabheight;
    }
    tableView.frame = tableViewFrame;
}

//上拉
-(IBAction)up:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    
    [btn addTarget:self action:@selector(dropdown:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"select_down.png"] forState:UIControlStateNormal];
    tableView.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
}

//隐藏下拉列表
-(void)hidden {
    if (tableView.hidden) {
        return;
    }
    [selectButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [selectButton addTarget:self action:@selector(dropdown:) forControlEvents:UIControlEventTouchUpInside];
    [selectButton setImage:[UIImage imageNamed:@"select_down.png"] forState:UIControlStateNormal];
    tableView.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [mytableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableArray!=nil && tableArray.count>0) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[tableArray objectAtIndex:indexPath.row]]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",[indexPath row]);
    NSString * s = [tableArray objectAtIndex:[indexPath row]];
    textField.text = s;
    //发送点击tableView的消息，传递点击index.row的值
    [[NSNotificationCenter defaultCenter]postNotificationName:@"postDropDownIndex" object:[NSNumber numberWithInt:[indexPath row]]];
    self.resultIndex = [indexPath row];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
