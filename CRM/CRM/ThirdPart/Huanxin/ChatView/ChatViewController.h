//
//  ChatViewController.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@class MedicalCase,Patient;
@interface ChatViewController : EaseMessageViewController

@property (nonatomic, strong)MedicalCase *mCase;

@end
