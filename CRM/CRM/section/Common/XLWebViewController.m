//
//  XLWebViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/29.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLWebViewController.h"
#import "ChatViewController.h"

@interface XLWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)NSURLRequest *request;
@end

@implementation XLWebViewController


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
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.hideRightButton) {
        [self setRightBarButtonWithTitle:@"发送"];
    }
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    _request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:_request];
}

- (void)onRightButtonAction:(id)sender{

    NSString *content = [NSString stringWithFormat:@"%@:%@",self.title,self.urlStr];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatVc = (ChatViewController *)vc;
            [chatVc sendTextMessage:content];
            [self popToViewController:vc animated:YES];
        }
    }
}

- (void)dealloc{
    
    NSLog(@"UIWebView Dealloc");
    
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];

    
    self.webView = nil;
    self.request = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_request];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
