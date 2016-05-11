//
//  EditAllergyViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
typedef NS_ENUM(NSInteger, EditAllergyViewControllerType) {
    EditAllergyViewControllerAllergy = 1,
    EditAllergyViewControllerAnamnesis = 2,
    EditAllergyViewControllerRemark = 3,
    EditAllergyViewControllerNickName = 4,
};

@class Patient,EditAllergyViewController;
@protocol EditAllergyViewControllerDelegate <NSObject>

@optional
- (void)editViewController:(EditAllergyViewController *)editVc didEditWithContent:(NSString *)content type:(EditAllergyViewControllerType)type;

@end
@interface EditAllergyViewController : TimViewController

@property (nonatomic, copy)NSString *content;

@property (nonatomic, assign)EditAllergyViewControllerType type;

@property (nonatomic, assign)NSInteger limit;

@property (nonatomic, strong)Patient *patient;

@property (nonatomic, weak)id<EditAllergyViewControllerDelegate> delegate;

@end
