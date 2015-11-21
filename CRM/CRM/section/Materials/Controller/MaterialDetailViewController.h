//
//  MaterialDetailViewController.h
//  CRM
//
//  Created by TimTiger on 6/2/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"

@class Material;
@interface MaterialDetailViewController : TimTableViewController

@property (nonatomic,retain) Material *material;

@end

