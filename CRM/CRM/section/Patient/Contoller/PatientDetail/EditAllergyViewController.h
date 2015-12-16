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

@class Patient;
@interface EditAllergyViewController : TimViewController

@property (nonatomic, copy)NSString *content;

@property (nonatomic, assign)EditAllergyViewControllerType type;

@property (nonatomic, strong)Patient *patient;

@end
