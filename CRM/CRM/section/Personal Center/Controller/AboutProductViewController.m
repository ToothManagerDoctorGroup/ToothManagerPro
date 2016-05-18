//
//  AboutProductViewController.m
//  MCRPages
//
//  Created by fankejun on 14-5-25.
//  Copyright (c) 2014年 CRM. All rights reserved.
//

#import "AboutProductViewController.h"
#import "CommonMacro.h"

@interface AboutProductViewController ()

@property (nonatomic,retain) UIWebView *webView;

@end

@implementation AboutProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于我们";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"aboutus" ofType:@"htm"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
