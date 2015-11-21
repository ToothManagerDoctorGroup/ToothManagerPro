//
//  UIBarButtonItem+THCAddtion.m
//  THCFramework
//

#import "UIBarButtonItem+TTMAddtion.h"
#import "NSString+TTMAddtion.h"

@implementation UIBarButtonItem (TTMAddtion)

+ (instancetype)barButtonItemWithImage:(NSString *)imageName
                         selectedImage:(NSString *)selectedImageName
                                action:(SEL)action
                                target:(id)target {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (selectedImageName) {
        [button setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    }
    button.bounds = CGRectMake(0, 0, button.currentBackgroundImage.size.width,
                               button.currentBackgroundImage.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}


+ (instancetype)barButtonItemWithTitle:(NSString *)title
                       normalImageName:(NSString *)normalImageName
                                action:(SEL)action
                                target:(id)target {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    CGFloat buttonW = [title measureFrameWithFont:button.titleLabel.font
                                             size:CGSizeMake(CGFLOAT_MAX, button.currentBackgroundImage.size.height)].size.width;
    button.bounds = CGRectMake(0, 0, buttonW + 20.f,
                               button.currentBackgroundImage.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                number:(NSNumber *)number
                                action:(SEL)action
                                target:(id)target {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    CGFloat buttonW = [title measureFrameWithFont:button.titleLabel.font
                                             size:CGSizeMake(CGFLOAT_MAX, button.currentBackgroundImage.size.height)].size.width;
    button.bounds = CGRectMake(0, 0, buttonW + 20.f,
                               button.currentBackgroundImage.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 数字,小红点
    CGFloat labelWH = 15.f;
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.backgroundColor = [UIColor redColor];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.layer.cornerRadius = labelWH / 2;
    numberLabel.clipsToBounds = YES;
    numberLabel.font = [UIFont systemFontOfSize:10.f];
    numberLabel.frame = CGRectMake(button.width - 10.f, - 20.f, labelWH, labelWH);
    [button addSubview:numberLabel];
    
    if ([number integerValue] == 0) {
        numberLabel.hidden = YES;
    } else {
        numberLabel.hidden = NO;
        if ([number integerValue] > 99) {
            numberLabel.text = @"N+";
        } else {
            numberLabel.text = [NSString stringwithNumber:number];
        }
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
    
}

@end
