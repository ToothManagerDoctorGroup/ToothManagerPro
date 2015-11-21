//
//  CRMHttpRequest+Sync.h
//  CRM
//
//  Created by du leiming on 23/10/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//


#import "CRMHttpRequest.h"

DEF_STATIC_CONST_STRING(DataSyncPost_Prefix, DataSyncPost);
DEF_URL PATIENT_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patient&action=add";
DEF_URL MATERIAL_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=material&action=add";
DEF_URL INTRODUCE_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=introducer&action=add";
DEF_URL MEDICAL_CASE_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalcase&action=add";
DEF_URL CTLIB_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=ctlib&action=add";
DEF_URL MEDICAL_EXPENSE_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalexpense&action=add";
DEF_URL MEDICAL_RECORD_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalrecord&action=add";
DEF_URL REPAIRDOCTOR_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=repairdoctor&action=add";
DEF_URL RESERVERECORD_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=reserverecord&action=add";
DEF_URL PATIENTCONSULTATION_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientconsultation&action=add";
DEF_URL PATIENT_INTRODUCER_MAP_ADD_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientintroducermap&action=add";

DEF_STATIC_CONST_STRING(DataSyncEdit_Prefix, DataSyncEdit);
DEF_URL PATIENT_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patient&action=edit";
DEF_URL MATERIAL_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=material&action=edit";
DEF_URL INTRODUCE_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=introducer&action=edit";
DEF_URL MEDICAL_CASE_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalcase&action=edit";
DEF_URL CTLIB_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=ctlib&action=edit";
DEF_URL MEDICAL_EXPENSE_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalexpense&action=edit";
DEF_URL MEDICAL_RECORD_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalrecord&action=edit";
DEF_URL REPAIRDOCTOR_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=repairdoctor&action=edit";
DEF_URL RESERVERECORD_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=reserverecord&action=edit";
DEF_URL PATIENTCONSULTATION_EDIT_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientconsultation&action=edit";

DEF_STATIC_CONST_STRING(DataSyncDelete_Prefix, DataSyncDelete);
DEF_URL PATIENT_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patient&action=delete";
DEF_URL MATERIAL_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=material&action=delete";
DEF_URL INTRODUCE_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=introducer&action=delete";
DEF_URL MEDICAL_CASE_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalcase&action=delete";
DEF_URL CTLIB_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=ctlib&action=delete";
DEF_URL MEDICAL_EXPENSE_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalexpense&action=delete";
DEF_URL MEDICAL_RECORD_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=medicalrecord&action=delete";
DEF_URL REPAIRDOCTOR_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=repairdoctor&action=delete";
DEF_URL RESERVERECORD_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=reserverecord&action=delete";
DEF_URL PATIENTCONSULTATION_DELETE_URL = @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patientconsultation&action=delete";

DEF_STATIC_CONST_STRING(DataSyncGet_Prefix, DataSyncGet);
//DEF_URL DOC_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=doctorinfo";
DEF_URL DOC_GET_URL = @"http://122.114.62.57/his.crm/ashx/DoctorIntroducerMapHandler.ashx?action=getdoctor";
DEF_URL MATERIAL_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=material";
DEF_URL INTRODUCE_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=introducer";
DEF_URL PATIENT_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=patient";
DEF_URL REPAIRDOCTOR_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=repairdoctor";
DEF_URL RESERVERECORD_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=reserverecord";
DEF_URL CTLIB_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=ctlib";
DEF_URL MEDICAL_CASE_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=medicalcase";
DEF_URL MEDICAL_EXPENSE_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=medicalexpense";
DEF_URL MEDICAL_RECORD_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=medicalrecord";
DEF_URL MEDICAL_RESEV_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=medicalreserve";
DEF_URL PATIENT_INTRODUCER_MAP_GET_URL = @"http://122.114.62.57/his.crm/ashx/PatientIntroducerMapHandler.ashx?action=getdoctor";
DEF_URL PATIENTCONSULTATION_GET_URL = @"http://122.114.62.57/his.crm/ashx/SyncGet.ashx?table=patientconsultation";

DEF_URL ImageDown = @"http://122.114.62.57/his.crm/UploadFiles/";

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

- (void)getDoctorTable;

- (void)getMaterialTable;

- (void)getIntroducerTable;

- (void)getPatientTable;

- (void)getReserverecordTable;

- (void)getPatIntrMapTable;

- (void)getRepairDoctorTable;

- (void)getMedicalResvTable;

- (void)getCTLibTable;

- (void)getMedicalCaseTable;

- (void)getMedicalExpenseTable;

- (void)getMedicalRecordTable;
//miss reserve record

- (void)getPatientConsulationTable;
@end




