//
//  ServerPrivacyViewController.m
//  CRM
//
//  Created by TimTiger on 7/12/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "ServerPrivacyViewController.h"
#import "CommonMacro.h"

@interface ServerPrivacyViewController ()

@property (nonatomic,retain) UIWebView *webView;

@end

@implementation ServerPrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"种牙管家服务协议";
    if (self.isPush) {
        [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    } else  {
        [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    }
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"htm"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
