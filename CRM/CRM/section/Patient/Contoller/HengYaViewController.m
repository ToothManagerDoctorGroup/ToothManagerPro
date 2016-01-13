//
//  HengYaViewController.m
//  CRM
//
//  Created by lsz on 15/10/22.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "HengYaViewController.h"
#import "CommonMacro.h"
#import "JSONKit.h"

@interface HengYaViewController (){
    NSMutableArray *hengYaArray;
    
    NSMutableArray *shangHeArray;
    NSMutableArray *xiaHeArray;
    NSMutableArray *quanKouArray;
    __weak IBOutlet UIButton *shangHeBtn;
    __weak IBOutlet UIButton *xiaHeBtn;
    __weak IBOutlet UIButton *quanKouBtn;
}

@end

@implementation HengYaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(320, 580);
    if(SCREEN_HEIGHT >= 568){
       // self.scrollView.scrollEnabled = NO;
    }

    CGRect rect = self.scrollView.frame;
    rect.origin.y = MIN(0, self.scrollView.contentOffset.y);
    self.scrollView.frame = rect;

    hengYaArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    shangHeArray = [[NSMutableArray alloc]initWithObjects:@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28", nil];
    xiaHeArray = [[NSMutableArray alloc]initWithObjects:@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48", nil];
    quanKouArray = [[NSMutableArray alloc]initWithObjects:@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48", nil];
    
//    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]init];
//    [tapges addTarget:self action:@selector(disMissView)];
//    tapges.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:tapges];
    if ([self.hengYaString isEqualToString:@"无"]) {
        return;
    }else if ([self.hengYaString isEqualToString:@"上颌"]) {
        [self shClick:shangHeBtn];
    }else if([self.hengYaString isEqualToString:@"下颌"]){
        [self xhClick:xiaHeBtn];
    }else if ([self.hengYaString isEqualToString:@"全口"]){
        [self qkClick:quanKouBtn];
    }else if(self.hengYaString.length > 0 && [self.hengYaString containsString:@","]){
        if(self.hengYaString.length > 0 && [self isShuZi:self.hengYaString]){
            NSArray *hen = [self.hengYaString componentsSeparatedByString:@","];
            for(NSInteger i = 0;i<[hen count];i++){
                UIButton *button = (UIButton *)[self.view viewWithTag:[[hen objectAtIndex:i]integerValue]];
                button.selected = YES;
                [hengYaArray addObject:hen[i]];
            }
        }
    }else{
        return;
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
    [self.delegate removeHengYaVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)shClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        button.selected = NO;
        //判断全口按钮是否被选中
        if (quanKouBtn.selected) {
            quanKouBtn.selected = NO;
        }
        
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:shangHeArray[i]];
        }
    }else{
        button.selected = YES;
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:shangHeArray[i]];
        }
        for(NSInteger i = 0;i<[shangHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[shangHeArray objectAtIndex:i]integerValue]];
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
            UIButton *button = (UIButton *)[self.view viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
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
            UIButton *button = (UIButton *)[self.view viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:xiaHeArray[i]];
        }
        for(NSInteger i = 0;i<[xiaHeArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[xiaHeArray objectAtIndex:i]integerValue]];
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
            UIButton *button = (UIButton *)[self.view viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = NO;
            [hengYaArray removeObject:quanKouArray[i]];
        }
    }else{
        button.selected = YES;
        shangHeBtn.selected = YES;
        xiaHeBtn.selected = YES;
        [hengYaArray removeAllObjects];
        for(NSInteger i = 0;i<[quanKouArray count];i++){
            UIButton *button = (UIButton *)[self.view viewWithTag:[[quanKouArray objectAtIndex:i]integerValue]];
            button.selected = YES;
            [hengYaArray addObject:quanKouArray[i]];
        }
    }
}
- (IBAction)qieHuanVC:(id)sender {
    [self.delegate changeToRuYaVC];
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
