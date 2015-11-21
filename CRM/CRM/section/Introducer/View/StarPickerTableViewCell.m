//
//  StarPickerTableViewCell.m
//  CRM
//
//  Created by TimTiger on 6/1/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "StarPickerTableViewCell.h"
#import "TimStarTextField.h"

@interface StarPickerTableViewCell () <UITextFieldDelegate>

@property (nonatomic,retain) TimStarTextField *textField;

@end

@implementation StarPickerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = CGRectMake(60,(self.bounds.size.height-30)/2, 200, 30);

}

- (void)setupView {
    self.textField = [[TimStarTextField alloc]initWithFrame:CGRectMake(60, 0, 200, 30)];
    self.textField.delegate = self;
    [self.contentView addSubview:self.textField];
}

- (void)setLevel:(NSInteger)level {
    self.textField.starLevel = level;
}

- (NSInteger)level {
    return self.textField.starLevel;
}

@end
