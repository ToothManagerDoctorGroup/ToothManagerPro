//
//  TimUIMacro.h
//  CRM
//
//  Created by TimTiger on 5/21/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#ifndef CRM_TimUIMacro_h
#define CRM_TimUIMacro_h


#import <Availability.h>

#ifdef __cplusplus
#define TIMUIKIT_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define TIMUIKIT_EXTERN	     extern __attribute__((visibility ("default")))
#endif

#define TIMUIKIT_STATIC_INLINE	static inline

#endif
