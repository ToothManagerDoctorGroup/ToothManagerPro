//
//  RuYaViewController.m
//  CRM
//
//  Created by lsz on 15/10/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "RuYaViewController.h"

@interface RuYaViewController (){
    NSMutableArray *ruYaArray;
    __weak IBOutlet UIButton *shangHeBtn;
    __weak IBOutlet UIButton *xiaHeBtn;
    __weak IBOutlet UIButton *quanKouBtn;
    
    NSMutableArray *shangHeArray;
    NSMutableArray *xiaHeArray;
    NSMutableArray *quanKouArray;
}

@end

@implementation RuYaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(320, 580);
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]init];
    [tapges addTarget:self action:@selector(disMissView)];
    tapges.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapges];
    
    ruYaArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    shangHeArray = [[NSMutableArray alloc]initWithObjects:@"51",@"52",@"53",@"54",@"55",@"61",@"62",@"63",@"64",@"65", nil];
    xiaHeArray = [[NSMutableArray alloc]initWithObjects:@"71",@"72",@"73",@"74",@"75",@"81",@"82",@"83",@"84",@"85", nil];
    quanKouArray = [[NSMutableArray alloc]initWithObjects:@"51",@"52",@"53",@"54",@"55",@"61",@"62",@"63",@"64",@"65",@"71",@"72",@"73",@"74",@"75",@"81",@"82",@"83",@"84",@"85", nil];
    
    if(self.ruYaString.length > 0 && ![self isShuZi:self.ruYaString]){
        NSArray *ru = [self.ruYaString componentsSeparatedByString:@","];
        for(NSInteger i = 0;i<[ru count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[ru objectAtIndex:i]integerValue]];
            button.selected = YES;
            [ruYaArray addObject:ru[i]];
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
    // [self.view removeFromSuperview];
    [self.delegate removeRuYaVC];
}
- (IBAction)shClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:shangHeArray[i]];
        }
    }else{
        button.selected = YES;
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:shangHeArray[i]];
        }
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
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
            UIButton *button = (UIButton *)[self.view viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:xiaHeArray[i]];
        }
    }else{
        button.selected = YES;
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:xiaHeArray[i]];
        }
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
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
            UIButton *button = (UIButton *)[self.view viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [ruYaArray removeObject:quanKouArray[i]];
        }
    }else{
        button.selected = YES;
        shangHeBtn.selected = YES;
        xiaHeBtn.selected = YES;
        [ruYaArray removeAllObjects];
        for(NSInteger i = 0;i<[quanKouArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [ruYaArray addObject:quanKouArray[i]];
        }
    }
}

- (IBAction)qieHuanVC:(id)sender {
    [self.delegate changeToHengYaVC];
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
    }else{
        button.selected = YES;
        [ruYaArray addObject:[NSString stringWithFormat:@"%ld",button.tag]];
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
    [self.delegate queDingRuYa:ruYaArray];
}
@end
