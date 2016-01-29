//
//  XLAssistenceDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAssistenceDetailViewController.h"
#import "XLLongImageScrollView.h"

@interface XLAssistenceDetailViewController ()

@property (nonatomic, strong)XLLongImageScrollView *imageScrollView;//图片滚动视图

@end

@implementation XLAssistenceDetailViewController

- (XLLongImageScrollView *)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView = [[XLLongImageScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height)];
        _imageScrollView.image = self.image;
        [self.view addSubview:_imageScrollView];
    }
    return _imageScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MyColor(248, 248, 248);
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    [self imageScrollView];
}

- (void)dealloc{
    self.imageScrollView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
