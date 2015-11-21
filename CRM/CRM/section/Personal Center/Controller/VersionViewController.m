//
//  VersionViewController.m
//  CRM
//
//  Created by TimTiger on 14-7-23.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "VersionViewController.h"
#import "AFNetworking.h"
#import "TimAlertView.h"
#import "UIApplication+Version.h"
#import "CRMMacro.h"
#import "GDTMobInterstitial.h"

@interface VersionViewController ()
@property (nonatomic,retain) GDTMobInterstitial *interstitialObj;
@end

@implementation VersionViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"版本检测";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

- (void)initView {
    [super initView];
    _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:@"1104111725"
                                                      placementId:@"5020209151364135"];
    _interstitialObj.isGpsOn = NO; //【可选】设置GPS开关
    //预加载⼲⼴广告
    [_interstitialObj loadAd];
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本 %@",[UIApplication currentVersion]];
    [UIApplication checkNewVersionWithAppleID:APPLEID handler:^(BOOL newVersion, NSURL *updateURL) {
        if (newVersion == YES) {
            TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"提示" message:@"有新的版本可使用" cancelHandler:^{
                
            } comfirmButtonHandlder:^{
                [UIApplication updateApplicationWithURL:updateURL];
            }];
            [alertView show];
        } else {
            self.versionLabel.text = [NSString stringWithFormat:@"当前已是最新版本 %@",[UIApplication currentVersion]];
        }
    }];
//    if ([_interstitialObj isReady]) {
    [self performSelector:@selector(loadAd) withObject:nil afterDelay:5.0f];
//    }
}

- (void)loadAd {
    [_interstitialObj presentFromRootViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
