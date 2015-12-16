//
//  AddressBookViewController.h
//  CRM
//
//  Created by TimTiger on 6/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimFramework.h"


typedef NS_ENUM(NSInteger, ImportType) {
    ImportTypeIntroducer = 1,
    ImportTypePatients = 2,
    ImportTypeRepairDoctor = 3,
};

@interface AddressBookViewController : TimDisplayViewController

@property (nonatomic,readwrite) ImportType type;

@end

@interface AddressBookCellMode : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) UIImage *image;
@property (nonatomic,readwrite) BOOL hasAdded;

@end