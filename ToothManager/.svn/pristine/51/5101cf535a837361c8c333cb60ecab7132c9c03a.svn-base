//
//  TTMAboutController.m
//  ToothManager
//

#import "TTMAboutController.h"

@interface TTMAboutController ()


@end

@implementation TTMAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    [self setupWebView];
}
/**
 *  加载关于我们的内容
 */
- (void)setupWebView {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"member_about" ofType:@"html"];
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
