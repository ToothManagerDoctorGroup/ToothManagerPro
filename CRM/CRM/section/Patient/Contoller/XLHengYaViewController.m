//
//  XLHengYaViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/2/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLHengYaViewController.h"
#import "CommonMacro.h"
#import "JSONKit.h"
#import "NSString+TTMAddtion.h"

@interface XLHengYaViewController (){
    NSMutableArray *hengYaArray;
    
    NSMutableArray *shangHeArray;
    NSMutableArray *xiaHeArray;
    NSMutableArray *quanKouArray;
    __weak IBOutlet UIButton *shangHeBtn;
    __weak IBOutlet UIButton *xiaHeBtn;
    __weak IBOutlet UIButton *quanKouBtn;
    __weak IBOutlet UITableViewCell *_henyaCell;
}

@end

@implementation XLHengYaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = .8;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-54, 0, 0, 0);
    
    hengYaArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    shangHeArray = [[NSMutableArray alloc]initWithObjects:@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28", nil];
    xiaHeArray = [[NSMutableArray alloc]initWithObjects:@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48", nil];
    quanKouArray = [[NSMutableArray alloc]initWithObjects:@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48", nil];

    if ([self.hengYaString isEqualToString:@"无"]) {
        return;
    }else if ([self.hengYaString isEqualToString:@"上颌"]) {
        [self shClick:shangHeBtn];
    }else if([self.hengYaString isEqualToString:@"下颌"]){
        [self xhClick:xiaHeBtn];
    }else if ([self.hengYaString isEqualToString:@"全口"]){
        [self qkClick:quanKouBtn];
    }else if(self.hengYaString.length > 0 && [self.hengYaString isContainsString:@","]){
        if(self.hengYaString.length > 0 && [self isShuZi:self.hengYaString]){
            NSArray *hen = [self.hengYaString componentsSeparatedByString:@","];
            for(NSInteger i = 0;i<[hen count];i++){
                UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[hen objectAtIndex:i]integerValue]];
                button.selected = YES;
                [hengYaArray addObject:hen[i]];
            }
        }
    }
}

-(BOOL)isShuZi:(NSString *)str {
    NSRange range = NSMakeRange(0, 1);
    NSString *subString = [str substringWithRange:range];
    if([subString integerValue] >= 0 && [subString integerValue] <=9){
        return YES;
    }
    return NO;
}
-(void)disMissView{
    [self.delegate removeHengYaVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)shClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        //判断全口按钮是否被选中
        if (quanKouBtn.selected) {
            quanKouBtn.selected = NO;
        }
        
        
        
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:shangHeArray[i]];
        }
    }else{
        button.selected = YES;
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:shangHeArray[i]];
        }
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [hengYaArray addObject:shangHeArray[i]];
        }
        if(hengYaArray.count == 32){
            quanKouBtn.selected = YES;
        }
    }
}
- (IBAction)xhClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:xiaHeArray[i]];
        }
        //判断全口按钮是否被选中
        if (quanKouBtn.selected) {
            quanKouBtn.selected = NO;
        }
        
    }else{
        button.selected = YES;
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:xiaHeArray[i]];
        }
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [hengYaArray addObject:xiaHeArray[i]];
        }
        if(hengYaArray.count == 32){
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
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:quanKouArray[i]];
        }
    }else{
        button.selected = YES;
        shangHeBtn.selected = YES;
        xiaHeBtn.selected = YES;
        [hengYaArray removeAllObjects];
        for(NSInteger i = 0;i<[quanKouArray count];i++){
            UIButton *button = (UIButton *)[_henyaCell.contentView viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [hengYaArray addObject:quanKouArray[i]];
        }
    }
}

- (IBAction)changeToRuYa:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    if (control.selectedSegmentIndex == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeToRuYaVC)]) {
            [self.delegate changeToRuYaVC];
        }
    }
}

- (IBAction)btnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        [hengYaArray removeObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        
        if ([shangHeArray containsObject:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
            shangHeBtn.selected = NO;
        }
        
        if ([xiaHeArray containsObject:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
            xiaHeBtn.selected = NO;
        }
        quanKouBtn.selected = NO;
    }else{
        button.selected = YES;
        [hengYaArray addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        
        //全口
        if (hengYaArray.count == 32) {
            shangHeBtn.selected = YES;
            xiaHeBtn.selected = YES;
            quanKouBtn.selected = YES;
        }else{
            
            if (hengYaArray.count >= 16) {
                int shIndex = 0;
                for (NSString *str in shangHeArray) {
                    if ([hengYaArray containsObject:str]) {
                        shIndex++;
                    }
                }
                if (shIndex == 16) {
                    shangHeBtn.selected = YES;
                }
                int xhIndex = 0;
                for (NSString *str in xiaHeArray) {
                    if ([hengYaArray containsObject:str]) {
                        xhIndex++;
                    }
                }
                if (xhIndex == 16) {
                    xiaHeBtn.selected = YES;
                }
            }
        }
    }
}

- (IBAction)queDingClick:(id)sender {
    hengYaArray = [NSMutableArray arrayWithArray:[hengYaArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
    }else if (shangHeBtn.selected && hengYaArray.count == 16){
        toothStr = @"上颌";
    }else if (xiaHeBtn.selected && hengYaArray.count == 16){
        toothStr = @"下颌";
    }else{
        toothStr = @"未连续";
    }
    
    if ([self.delegate respondsToSelector:@selector(queDingHengYa:toothStr:)]) {
        [self.delegate queDingHengYa:hengYaArray toothStr:toothStr];
    }
}
- (IBAction)cancelAction:(id)sender {
    [self disMissView];
}


@end
