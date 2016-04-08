//
//  CRMHttpRequest+Sync.h
//  CRM
//
//  Created by du leiming on 23/10/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//


#import "CRMHttpRequest.h"

DEF_STATIC_CONST_STRING(DataSyncPost_Prefix, DataSyncPost);
//DEF_URL PATIENT_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patient&action=add";
#define PATIENT_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patient&action=add",DomainName,Method_His_Crm]

//DEF_URL MATERIAL_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=material&action=add";
#define MATERIAL_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=material&action=add",DomainName,Method_His_Crm]

//DEF_URL INTRODUCE_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=introducer&action=add";
#define INTRODUCE_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=introducer&action=add",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_CASE_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalcase&action=add";
#define MEDICAL_CASE_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalcase&action=add",DomainName,Method_His_Crm]

//DEF_URL CTLIB_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=ctlib&action=add";
#define CTLIB_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=ctlib&action=add",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_EXPENSE_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalexpense&action=add";
#define MEDICAL_EXPENSE_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalexpense&action=add",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_RECORD_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalrecord&action=add";
#define MEDICAL_RECORD_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalrecord&action=add",DomainName,Method_His_Crm]

//DEF_URL REPAIRDOCTOR_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=repairdoctor&action=add";
#define REPAIRDOCTOR_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=repairdoctor&action=add",DomainName,Method_His_Crm]

//DEF_URL RESERVERECORD_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=reserverecord&action=add";
#define RESERVERECORD_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=reserverecord&action=add",DomainName,Method_His_Crm]

//DEF_URL PATIENTCONSULTATION_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientconsultation&action=add";
#define PATIENTCONSULTATION_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patientconsultation&action=add",DomainName,Method_His_Crm]

//DEF_URL PATIENT_INTRODUCER_MAP_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientintroducermap&action=add";
#define PATIENT_INTRODUCER_MAP_ADD_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patientintroducermap&action=add",DomainName,Method_His_Crm]

DEF_STATIC_CONST_STRING(DataSyncEdit_Prefix, DataSyncEdit);
//DEF_URL PATIENT_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patient&action=edit";
#define PATIENT_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patient&action=edit",DomainName,Method_His_Crm]

//DEF_URL MATERIAL_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=material&action=edit";
#define MATERIAL_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=material&action=edit",DomainName,Method_His_Crm]

//DEF_URL INTRODUCE_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=introducer&action=edit";
#define INTRODUCE_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=introducer&action=edit",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_CASE_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalcase&action=edit";
#define MEDICAL_CASE_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalcase&action=edit",DomainName,Method_His_Crm]

//DEF_URL CTLIB_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=ctlib&action=edit";
#define CTLIB_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=ctlib&action=edit",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_EXPENSE_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalexpense&action=edit";
#define MEDICAL_EXPENSE_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalexpense&action=edit",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_RECORD_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalrecord&action=edit";
#define MEDICAL_RECORD_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalrecord&action=edit",DomainName,Method_His_Crm]

//DEF_URL REPAIRDOCTOR_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=repairdoctor&action=edit";
#define REPAIRDOCTOR_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=repairdoctor&action=edit",DomainName,Method_His_Crm]

//DEF_URL RESERVERECORD_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=reserverecord&action=edit";
#define RESERVERECORD_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=reserverecord&action=edit",DomainName,Method_His_Crm]

//DEF_URL PATIENTCONSULTATION_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientconsultation&action=edit";
#define PATIENTCONSULTATION_EDIT_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patientconsultation&action=edit",DomainName,Method_His_Crm]

DEF_STATIC_CONST_STRING(DataSyncDelete_Prefix, DataSyncDelete);
//DEF_URL PATIENT_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patient&action=delete";
#define PATIENT_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patient&action=delete",DomainName,Method_His_Crm]

//DEF_URL MATERIAL_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=material&action=delete";
#define MATERIAL_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=material&action=delete",DomainName,Method_His_Crm]

//DEF_URL INTRODUCE_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=introducer&action=delete";
#define INTRODUCE_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=introducer&action=delete",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_CASE_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalcase&action=delete";
#define MEDICAL_CASE_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalcase&action=delete",DomainName,Method_His_Crm]

//DEF_URL CTLIB_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=ctlib&action=delete";
#define CTLIB_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=ctlib&action=delete",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_EXPENSE_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalexpense&action=delete";
#define MEDICAL_EXPENSE_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalexpense&action=delete",DomainName,Method_His_Crm]

//DEF_URL MEDICAL_RECORD_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalrecord&action=delete";
#define MEDICAL_RECORD_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalrecord&action=delete",DomainName,Method_His_Crm]

//DEF_URL REPAIRDOCTOR_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=repairdoctor&action=delete";
#define REPAIRDOCTOR_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=repairdoctor&action=delete",DomainName,Method_His_Crm]

//DEF_URL RESERVERECORD_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=reserverecord&action=delete";
#define RESERVERECORD_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=reserverecord&action=delete",DomainName,Method_His_Crm]

//DEF_URL PATIENTCONSULTATION_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientconsultation&action=delete";
#define PATIENTCONSULTATION_DELETE_URL [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patientconsultation&action=delete",DomainName,Method_His_Crm]



DEF_STATIC_CONST_STRING(DataSyncGet_Prefix, DataSyncGet);

#define DOC_GET_URL [NSString stringWithFormat:@"%@%@/%@/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define SYNC_COMMON_GET_URL [NSString stringWithFormat:@"%@%@/%@/SyncGet.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define PATIENT_INTRODUCER_MAP_GET_URL [NSString stringWithFormat:@"%@%@/%@/PatientIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define ImageDown [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm]

@protocol dataSyncResult <NSObject>

@required
- (void)dataSycnResultWithTable:(NSString *)TableId isSucesseful:(BOOL)isSucesseful;

@end


@interface CRMHttpRequest (Sync)

@property (nonatomic, weak) id delegate;



//add
//-(void)postAllNeedSyncDoctor:(NSArray *)doctor;

-(void)postAllNeedSyncPatient:(NSArray *)patient;

-(void)postAllNeedSyncMaterial:(NSArray *)material;


-(void)postAllNeedSyncIntroducer:(NSArray *)introducer;

-(void)postAllNeedSyncPatientIntroducerMap:(NSArray *)patIntr;

-(void)postAllNeedSyncMedical_case:(NSArray *)medical_case;

-(void)postAllNeedSyncCt_lib:(NSArray *)ct_lib;

-(void)postAllNeedSyncMedical_expense:(NSArray *)medical_expense;

-(void)postAllNeedSyncMedical_record:(NSArray *)medical_record;

-(void)postAllNeedSyncReserve_record:(NSArray *)reserve_record;

//-(void)postAllNeedSyncMedical_reserve:(NSArray *)medical_reserve;

-(void)postAllNeedSyncRepair_doctor:(NSArray *)repair_doctor;

-(void)postAllNeedSyncPatient_consultation:(NSArray *)patient_consultation;

//edit

-(void)editAllNeedSyncPatient:(NSArray *)patient;

-(void)editAllNeedSyncMaterial:(NSArray *)material;


-(void)editAllNeedSyncIntroducer:(NSArray *)introducer;

-(void)editAllNeedSyncMedical_case:(NSArray *)medical_case;


-(void)editAllNeedSyncCt_lib:(NSArray *)ct_lib;


-(void)editAllNeedSyncMedical_expense:(NSArray *)medical_expense;

-(void)editAllNeedSyncMedical_record:(NSArray *)medical_record;

-(void)editAllNeedSyncReserve_record:(NSArray *)reserve_record;

-(void)editAllNeedSyncRepair_Doctor:(NSArray *)repair_doctor;

//-(void)editAllNeedSyncMedical_reserve:(NSArray *)medical_reserve;

-(void)editAllNeedSyncPatient_consultation:(NSArray *)patient_consultation;


//delete

-(void)deleteAllNeedSyncPatient:(NSArray *)patient;

-(void)deleteAllNeedSyncMaterial:(NSArray *)material;


-(void)deleteAllNeedSyncIntroducer:(NSArray *)introducer;

-(void)deleteAllNeedSyncMedical_case:(NSArray *)medical_case;


-(void)deleteAllNeedSyncCt_lib:(NSArray *)ct_lib;


-(void)deleteAllNeedSyncMedical_expense:(NSArray *)medical_expense;

-(void)deleteAllNeedSyncMedical_record:(NSArray *)medical_record;


//-(void)deleteAllNeedSyncMedical_reserve:(NSArray *)medical_reserve;

-(void)deleteAllNeedSyncReserve_record:(NSArray *)reserve_record;

-(void)deleteAllNeedSyncRepair_doctor:(NSArray *)repair_doctor;


-(void)deleteAllNeedSyncPatient_consultation:(NSArray *)patient_consultation;




//get

- (void)getDoctorTable;//同步医生信息

- (void)getMaterialTable;//同步耗材信息

- (void)getIntroducerTable;//同步介绍人信息

- (void)getPatientTable;//同步患者信息

- (void)getReserverecordTable;//同步预约信息

- (void)getPatIntrMapTable;//同步患者介绍人信息

- (void)getRepairDoctorTable;//同步修复医生信息

- (void)getMedicalResvTable;

- (void)getCTLibTable; //需要重复下载

- (void)getMedicalCaseTable; //需要重复下载

- (void)getMedicalExpenseTable;//需要重复下载

- (void)getMedicalRecordTable; //需要重复下载
//miss reserve record

- (void)getPatientConsulationTable;
@end




