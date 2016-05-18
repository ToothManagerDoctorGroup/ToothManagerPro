//
//  XLGroupMembersView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  群组成员的view
 */
@class MedicalCase;
@interface XLGroupMembersView : UIView

@property (nonatomic, strong)MedicalCase *mCase; //群组所属病历

@property (nonatomic, strong)NSArray *members;


- (CGFloat)getHeight;

@end
