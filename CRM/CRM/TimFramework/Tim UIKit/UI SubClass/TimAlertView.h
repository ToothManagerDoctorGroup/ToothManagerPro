//
//  TimAlertView.h
//  CRM
//
//  Created by TimTiger on 6/2/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertButtonHandler)();

@interface TimAlertView : UIAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelHandler:(AlertButtonHandler)cancelHandler comfirmButtonHandlder:(AlertButtonHandler)comfirmHandler;


- (id)initWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel certain:(NSString *)certain cancelHandler:(AlertButtonHandler)cancelHandler comfirmButtonHandlder:(AlertButtonHandler)comfirmHandler;
@end
