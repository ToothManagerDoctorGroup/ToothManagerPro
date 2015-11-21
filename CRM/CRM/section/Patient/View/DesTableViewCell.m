//
//  DesTableViewCell.m
//  CRM
//
//  Created by TimTiger on 5/24/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DesTableViewCell.h"
#import "TimFramework.h"


@interface DesTableViewCell () <UITextViewDelegate>

@end

@implementation DesTableViewCell
@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)setupView {
    textView = [[TimTextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    textView.delegate = self;
    textView.layer.cornerRadius = 5.0f;
    textView.layer.shadowColor = [[UIColor grayColor]CGColor];
    textView.layer.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:textView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    textView.frame = CGRectMake(60, 0,200, self.bounds.size.height-5);
}

#pragma mark - UItextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBecomeFirstResponder:)]) {
        [self.delegate didBecomeFirstResponder:self];
    }
    return YES;
}

@end
