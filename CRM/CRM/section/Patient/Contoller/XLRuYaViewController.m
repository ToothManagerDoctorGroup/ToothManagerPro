//
//  XLRuYaViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/2/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLRuYaViewController.h"
#import "NSString+TTMAddtion.h"

@interface XLRuYaViewController (){
    NSMutableArray *ruYaArray;
    __weak IBOutlet UIButton *shangHeBtn;
    __weak IBOutlet UIButton *xiaHeBtn;
    __weak IBOutlet UIButton *quanKouBtn;
    
    NSMutableArray *shangHeArray;
    NSMutableArray *xiaHeArray;
    NSMutableArray *quanKouArray;
    __weak IBOutlet UITableViewCell *_ruyaCell;
}

@end

@implementation XLRuYaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化视图
    [self setUpView];
    //初始化数据
    [self setUpData];
}
#pragma mark - 初始化
- (void)setUpView{
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = .8;
    self.tableView.contentInset = UIEdgeInsetsMake(-54, 0, 0, 0);
}
- (void)setUpData{
    ruYaArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    shangHeArray = [[NSMutableArray alloc]initWithObjects:@"51",@"52",@"53",@"54",@"55",@"61",@"62",@"63",@"64",@"65", nil];
    xiaHeArray = [[NSMutableArray alloc]initWithObjects:@"71",@"72",@"73",@"74",@"75",@"81",@"82",@"83",@"84",@"85", nil];
    quanKouArray = [[NSMutableArray alloc]initWithObjects:@"51",@"52",@"53",@"54",@"55",@"61",@"62",@"63",@"64",@"65",@"71",@"72",@"73",@"74",@"75",@"81",@"82",@"83",@"84",@"85", nil];
    if ([self.ruYaString isEqualToString:@"无"]) {
        return;
    }else if ([self.ruYaString isEqualToString:@"上颌"]) {
        [self shClick:shangHeBtn];
    }else if([self.ruYaString isEqualToString:@"下颌"]){
        [self xhClick:xiaHeBtn];
    }else if ([self.ruYaString isEqualToString:@"全口"]){
        [self qkClick:quanKouBtn];
    }else if (self.ruYaString.length > 0 && [self isPureNumandCharacters:self.ruYaString] && ![self.ruYaString isContainsString:@","]){
        UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[self.ruYaString integerValue]];
        button.selected = YES;
        [ruYaArray addObject:self.ruYaString];
    }else if(self.ruYaString.length > 0 && [self.ruYaString isContainsString:@","]){
        if(self.ruYaString.length > 0 && ![self isPureNumandCharacters:self.ruYaString]){
            NSArray *ru = [self.ruYaString componentsSeparatedByString:@","];
            for(NSInteger i = 0;i<[ru count];i++){
                UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[ru objectAtIndex:i]integerValue]];
                button.selected = YES;
                [ruYaArray addObject:ru[i]];
            }
        }
    }
}

#pragma mark - 判断是否是数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

-(void)disMissView{
    [self.delegate removeRuYaVC];
}
- (IBAction)shClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:shangHeArray[i]];
        }
        //判断全口按钮是否被选中
        if (quanKouBtn.selected) {
            quanKouBtn.selected = NO;
        }
        
    }else{
        button.selected = YES;
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:shangHeArray[i]];
        }
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [ruYaArray addObject:shangHeArray[i]];
        }
        
        
        if(ruYaArray.count == 20){
            quanKouBtn.selected = YES;
        }
    }
}
- (IBAction)xhClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:xiaHeArray[i]];
        }
        
        //判断全口按钮是否被选中
        if (quanKouBtn.selected) {
            quanKouBtn.selected = NO;
        }
    }else{
        button.selected = YES;
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:xiaHeArray[i]];
        }
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [ruYaArray addObject:xiaHeArray[i]];
        }
        if(ruYaArray.count == 20){
            quanKouBtn.selected = YES;
        }
    }
}
- (IBAction)qkClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        shangHeBtn.selected = NO;
        xiaHeBtn.selected = NO;
        for(NSInteger i = 0;i<[quanKouArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:quanKouArray[i]];
        }
    }else{
        button.selected = YES;
        shangHeBtn.selected = YES;
        xiaHeBtn.selected = YES;
        [ruYaArray removeAllObjects];
        for(NSInteger i = 0;i<[quanKouArray count];i++){
            UIButton *button = (UIButton *)[_ruyaCell.contentView viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [ruYaArray addObject:quanKouArray[i]];
        }
    }
}

- (IBAction)changeToHengYa:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    if (control.selectedSegmentIndex == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeToHengYaVC)]) {
            [self.delegate changeToHengYaVC];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        [ruYaArray removeObject:[NSString stringWithFormat:@"%ld",button.tag]];
        
        if ([shangHeArray containsObject:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
            shangHeBtn.selected = NO;
        }
        
        if ([xiaHeArray containsObject:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
            xiaHeBtn.selected = NO;
        }
        quanKouBtn.selected = NO;
        
    }else{
        button.selected = YES;
        [ruYaArray addObject:[NSString stringWithFormat:@"%ld",button.tag]];
        
        //全口
        if (ruYaArray.count == 20) {
            shangHeBtn.selected = YES;
            xiaHeBtn.selected = YES;
            quanKouBtn.selected = YES;
        }else{
            
            if (ruYaArray.count >= 10) {
                int shIndex = 0;
                for (NSString *str in shangHeArray) {
                    if ([ruYaArray containsObject:str]) {
                        shIndex++;
                    }
                }
                if (shIndex == 10) {
                    shangHeBtn.selected = YES;
                }
                int xhIndex = 0;
                for (NSString *str in xiaHeArray) {
                    if ([ruYaArray containsObject:str]) {
                        xhIndex++;
                    }
                }
                if (xhIndex == 10) {
                    xiaHeBtn.selected = YES;
                }
            }
        }
    }
}
- (IBAction)queDingClick:(id)sender {
    ruYaArray = [NSMutableArray arrayWithArray:[ruYaArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([obj1 integerValue]>[obj2 integerValue]){
            return NSOrderedDescending;
        }else if ([obj1 integerValue]<[obj2 integerValue]){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }]];
    
    //判断当前有哪些按钮被选中
    NSString *toothStr;
    if (quanKouBtn.selected) {
        toothStr = @"全口";
    }else if (shangHeBtn.selected && ruYaArray.count == 10){
        toothStr = @"上颌";
    }else if (xiaHeBtn.selected && ruYaArray.count == 10){
        toothStr = @"下颌";
    }else{
        toothStr = @"未连续";
    }
    if ([self.delegate respondsToSelector:@selector(queDingRuYa:toothStr:)]) {
        [self.delegate queDingRuYa:ruYaArray toothStr:toothStr];
    }
}
- (IBAction)cancelAction:(id)sender {
    [self disMissView];
}
@end
