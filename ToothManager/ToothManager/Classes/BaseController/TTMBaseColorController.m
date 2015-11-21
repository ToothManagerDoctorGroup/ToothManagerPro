//
//  TTMBaseColorController.m
//  ToothManager
//

#import "TTMBaseColorController.h"

@interface TTMBaseColorController ()

@end

@implementation TTMBaseColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(244.0f, 244.0f, 244.0f);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIView *view in self.tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }
}


- (void)setupRightItem {
}

- (void)buttonAction:(UIButton *)button {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
