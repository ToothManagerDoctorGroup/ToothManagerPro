//
//  TTMGreenButton.m
//  ToothManager
//

#import "TTMGreenButton.h"

#define kMargin 10.f
#define kButtonH 40.f
#define kButtonW (ScreenWidth - 2 * kMargin)

@implementation TTMGreenButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"member_login_button_bg"] forState:UIControlStateNormal];
    
    self.size = CGSizeMake(kButtonW, kButtonH);
}


@end
