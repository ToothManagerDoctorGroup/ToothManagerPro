//
//  CaseDetailHeaderView.h
//  CRM
//
//  Created by TimTiger on 6/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseDetailHeaderView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *plantTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repairTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reverveTimeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *ctScrollView;
@property (nonatomic,retain) NSArray *ctImageArray;

@end
