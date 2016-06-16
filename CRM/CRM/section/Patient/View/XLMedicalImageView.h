//
//  XLMedicalImageView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  病历图片详情视图
 */
@class MedicalCase;
@interface XLMedicalImageView : UIView

@property (nonatomic, strong)MedicalCase *medicalCase;

@end
