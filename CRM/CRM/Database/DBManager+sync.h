//
//  DBManager+sync.h
//  CRM
//
//  Created by du leiming on 03/11/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"


@interface DBManager (Sync)


/*
 *@brief 获取Material表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncMaterial;
-(NSArray *)getAllEditNeedSyncMaterial;
-(NSArray *)getAllDeleteNeedSyncMaterial;

/*
 *@brief 获取Introducer表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncIntroducer;
-(NSArray *)getAllEditNeedSyncIntroducer;
-(NSArray *)getAllDeleteNeedSyncIntroducer;

/*
 *@brief 获取patient_introducer_map表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncPatientIntroducerMap;

/*
 *@brief 获取Patient表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncPatient;
-(NSArray *)getAllEditNeedSyncPatient;
-(NSArray *)getAllDeleteNeedSyncPatient;

/*
 *@brief 获取CT表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncCt_lib;
-(NSArray *)getAllEditNeedSyncCt_lib;
-(NSArray *)getAllDeleteNeedSyncCt_lib;

/*
 *@brief 获取Medical case表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncMedical_case;
-(NSArray *)getAllEditNeedSyncMedical_case;
-(NSArray *)getAllDeleteNeedSyncMedical_case;

/*
 *@brief 获取Medical expense表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncMedical_expense;
-(NSArray *)getAllEditNeedSyncMedical_expense;
-(NSArray *)getAllDeleteNeedSyncMedical_expense;

/*
 *@brief 获取Medical Record中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncMedical_record;
-(NSArray *)getAllEditNeedSyncMedical_record;
-(NSArray *)getAllDeleteNeedSyncMedical_record;

/*
 *@brief 获取Patient Consultation中全部需要更新的表项  会诊信息
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncPatient_consultation;
-(NSArray *)getAllEditNeedSyncPatient_consultation;
-(NSArray *)getAllDeleteNeedSyncPatient_consultation;

/*
 *@brief 获取local notification中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncLocal_Notification;
-(NSArray *)getAllEditNeedSyncLocal_Notification;
-(NSArray *)getAllDeleteNeedSyncLocal_Notification;

/*
 *@brief 获取repair doctor中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncRepair_Doctor;
-(NSArray *)getAllEditNeedSyncRepair_Doctor;
-(NSArray *)getAllDeleteNeedSyncRepair_Doctor;

@end
