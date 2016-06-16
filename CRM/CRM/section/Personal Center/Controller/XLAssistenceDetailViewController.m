//
//  XLAssistenceDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAssistenceDetailViewController.h"
#import "XLLongImageScrollView.h"
#import "XLAssistenceModel.h"

@interface XLAssistenceDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation XLAssistenceDetailViewController

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = self.model.help_des;
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSURL *url = [NSURL URLWithString:self.model.help_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)dealloc{
    self.webView = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
