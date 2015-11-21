//
//  TTMPrivateController.m
//  ToothManager
//

#import "TTMPrivateController.h"

@interface TTMPrivateController ()

@property (nonatomic, copy)   NSString *name;

@end

@implementation TTMPrivateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务和隐私条款";
    
    [self setupWebView];
}
/**
 *  加载服务和隐私条款内容
 */
- (void)setupWebView {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"member_private" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
