//
//  DBTableMode.m
//  CRM
//
//  Created by TimTiger on 5/15/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBTableMode.h"
#import "FMResultSet.h"
#import "TimFramework.h"
#import "CRMUserDefalut.h"
#import "UIDevice+OpenUDID.h"
#import "NSDate+Conversion.h"
#import "NSString+Conversion.h"
#import "AccountManager.h"
#import "MyDateTool.h"
#import "UIColor+Extension.h"
#import "NSString+TTMAddtion.h"

//NSString * const ITI = @"ITI";
//NSString * const DENTIS = @"DENTIS"; //诺贝尔，ITI，奥齿泰，费亚丹
//NSString * const NuoBeiEr = @"诺贝尔";
//NSString * const AoChiTai = @"奥齿泰";
//NSString * const FeiYaDan = @"费亚丹";
NSString * const MaterialStr = @"种植体";
NSString * const OtherStr = @"其它";
NSString * const Untreatment = @"未就诊";
NSString * const Unplanted = @"未种植"; //诺贝尔，ITI，奥齿泰，费亚丹
NSString * const Unrepaired = @"已种未修";
NSString * const Repaired = @"已修复";

@implementation DBTableMode

- (id)init {
    self = [super init];
    if (self) {
        _ckeyid = [self createCkeyId];
        _user_id = [CRMUserDefalut latestUserId];
        _doctor_id = [CRMUserDefalut latestUserId];
    }
    return self;
}

- (NSString *)createCkeyId {
    NSString *ckeyid = [CRMUserDefalut latestUserId];
    if ([NSString isEmptyString:ckeyid]) {
        ckeyid = @"";
    }
//    NSString *CFUDID = [UIDevice CFUUID];
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]*1000];
//    ckeyid = [ckeyid stringByAppendingString:CFUDID];
    ckeyid = [ckeyid stringByAppendingString:@"_"];
    ckeyid = [ckeyid stringByAppendingString:timeString];
    return ckeyid;
}

@end

@implementation Material
- (id)init {
    self = [super init];
    if (self) {
        self.mat_name = @"";
    }
    return self;
}

+ (Material *)materialWithResult:(FMResultSet *)result {
    Material *material = [[Material alloc]init];
    material.ckeyid = [result stringForColumn:@"ckeyid"];
    material.sync_time = [result stringForColumn:@"sync_time"];
    material.update_date = [result stringForColumn:@"update_time"];
    material.mat_name = [result stringForColumn:@"mat_name"];
    material.mat_type = [result intForColumn:@"mat_type"];
    material.mat_price = [result doubleForColumn:@"mat_price"];
    material.user_id = [result stringForColumn:@"user_id"];
    material.doctor_id = [result stringForColumn:@"doctor_id"];
    return material;
}

+ (Material *)MaterialFromMaterialResult:(NSDictionary *)mat {
    Material *tmpMaterial = [[Material alloc]init];
    
    tmpMaterial.ckeyid = [mat stringForKey:@"ckeyid"];
    tmpMaterial.user_id = [AccountManager currentUserid];
    tmpMaterial.mat_price = [[mat stringForKey:@"mat_price"] floatValue];
    tmpMaterial.mat_name = [mat stringForKey:@"mat_name"];
    tmpMaterial.mat_type = [[mat stringForKey:@"mat_type"] integerValue];
    tmpMaterial.sync_time = [mat stringForKey:@"sync_time"];
    tmpMaterial.update_date = [NSString defaultDateString];
    tmpMaterial.doctor_id = [mat stringForKey:@"doctor_id"];
    
    return tmpMaterial;
}

+ (MaterialType)typeIntegerWith:(NSString *)string {
    if ([string isEqualToString:MaterialStr]) {
        return MaterialTypeMaterial;
    }
    return MaterialTypeOther;
}

+ (NSString *)typeStringWith:(MaterialType)type {
    switch (type) {
        case MaterialTypeOther:
            return OtherStr;
            break;
        default:
            return MaterialStr;
            break;
    }
}

@end

@implementation MedicalCase

- (id)init {
    self = [super init];
    if (self) {
        self.case_name = @"";
        self.implant_time = @"";
        self.repair_doctor = @"";
    }
    return self;
}

+ (MedicalCase *)medicalCaseWithResult:(FMResultSet *)result {
    MedicalCase * medicalCase = [[MedicalCase alloc]init];
    medicalCase.ckeyid = [result stringForColumn:@"ckeyid"];
    medicalCase.sync_time = [result stringForColumn:@"sync_time"];
    medicalCase.patient_id = [result stringForColumn:@"patient_id"];
    medicalCase.case_name = [result stringForColumn:@"case_name"];
    medicalCase.creation_date = [result stringForColumn:@"creation_date"];
    medicalCase.implant_time = [result stringForColumn:@"implant_time"];
    medicalCase.next_reserve_time = [result stringForColumn:@"next_reserve_time"];
    medicalCase.repair_time = [result stringForColumn:@"repair_time"];
    medicalCase.case_status = [result intForColumn:@"case_status"];
    medicalCase.repair_doctor = [result stringForColumn:@"repair_doctor"];
    medicalCase.repair_doctor_name = [result stringForColumn:@"repair_doctor_name"];
    medicalCase.user_id = [result stringForColumn:@"user_id"];
    medicalCase.doctor_id = [result stringForColumn:@"doctor_id"];
    medicalCase.creation_date_sync = [result stringForColumn:@"creation_date_sync"];
    
    medicalCase.tooth_position = [result stringForColumn:@"tooth_position"];
    medicalCase.team_notice = [result stringForColumn:@"team_notice"];
    medicalCase.hxGroupId = [result stringForColumn:@"hxGroupId"];
    
    return medicalCase;
}

+ (MedicalCase *)MedicalCaseFromPatientMedicalCase:(NSDictionary *)medcas {
    
    MedicalCase *tmpMedicalCase = [[MedicalCase alloc]init];
    tmpMedicalCase.ckeyid = [medcas stringForKey:@"ckeyid"];
    tmpMedicalCase.user_id = [AccountManager currentUserid];
    tmpMedicalCase.case_name = [medcas stringForKey:@"case_name"];
    tmpMedicalCase.case_status = [[medcas stringForKey:@"case_status"] integerValue];
    tmpMedicalCase.implant_time = [medcas timeStringForKey:@"implant_time"];
    tmpMedicalCase.next_reserve_time = [medcas timeStringForKey:@"next_reserve_time"];
    tmpMedicalCase.patient_id = [medcas stringForKey:@"patient_id"];
    tmpMedicalCase.repair_doctor = [[medcas stringForKey:@"repair_doctor"] convertIfNill];
    tmpMedicalCase.repair_doctor_name = [medcas stringForKey:@"repair_doctor_name"];
    tmpMedicalCase.repair_time = [[medcas timeStringForKey:@"repair_time"] convertIfNill];
    tmpMedicalCase.update_date = [NSString defaultDateString];
    tmpMedicalCase.sync_time = [medcas stringForKey:@"sync_time"];
    tmpMedicalCase.doctor_id = [medcas stringForKey:@"doctor_id"];
    tmpMedicalCase.creation_date = [medcas stringForKey:@"creation_time"];
    
    tmpMedicalCase.tooth_position = [medcas stringForKey:@"tooth_position"];
    tmpMedicalCase.team_notice = [medcas stringForKey:@"team_notice"];
    tmpMedicalCase.hxGroupId = [medcas stringForKey:@"HxGroupId"];
    
    return tmpMedicalCase;

}

@end

@implementation MedicalExpense

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (MedicalExpense *)expenseWithResult:(FMResultSet *)result {
    MedicalExpense *expense = [[MedicalExpense alloc]init];
    expense.ckeyid = [result stringForColumn:@"ckeyid"];
    expense.sync_time = [result stringForColumn:@"sync_time"];
    expense.patient_id = [result stringForColumn:@"patient_id"];
    expense.mat_id = [result stringForColumn:@"mat_id"];
    expense.case_id = [result stringForColumn:@"case_id"];
    expense.expense_num = [result intForColumn:@"expense_num"];
    expense.expense_price = [result doubleForColumn:@"expense_price"];
    expense.expense_money = [result doubleForColumn:@"expense_money"];
    expense.update_date = [result stringForColumn:@"update_date"];
    expense.creation_date = [result stringForColumn:@"creation_date"];
    expense.user_id = [result stringForColumn:@"user_id"];
    expense.doctor_id = [result stringForColumn:@"doctor_id"];
    expense.creation_date_sync = [result stringForColumn:@"creation_date_sync"];
    return expense;
}

+ (MedicalExpense *)MEFromMEResult:(NSDictionary *)medEx
{
    MedicalExpense *tempExpense = [[MedicalExpense alloc]init];

    tempExpense.ckeyid = [medEx stringForKey:@"ckeyid"];
    tempExpense.case_id = [medEx stringForKey:@"case_id"];
    tempExpense.user_id = [AccountManager currentUserid];
    tempExpense.expense_money = [[medEx stringForKey:@"expense_money"] floatValue];
    tempExpense.expense_num = [[medEx stringForKey:@"expense_num"] integerValue];
    tempExpense.expense_price = [[medEx stringForKey:@"expense_price"] floatValue];
    tempExpense.mat_id = [medEx stringForKey:@"mat_id"];
    tempExpense.patient_id = [medEx stringForKey:@"patient_id"];
    tempExpense.sync_time = [medEx stringForKey:@"sync_time"];
    tempExpense.doctor_id = [medEx stringForKey:@"doctor_id"];
    tempExpense.update_date = [NSString defaultDateString];
    tempExpense.creation_date = [medEx stringForKey:@"creation_time"];
    
    return tempExpense;
    
}

@end

@implementation Patient

- (id)init {
    self = [super init];
    if (self) {
        self.patient_name = @"";
        self.patient_phone = @"";
        self.patient_age = @"0";
        self.patient_avatar = @"";
        self.patient_gender = @"2";
        self.introducer_id = @"";
        self.patient_status = PatientStatusUntreatment;
        self.ori_user_id = @"";
        self.intr_name = @"";
        
        self.patient_allergy = @"";
        self.patient_remark = @"";
        self.idCardNum = @"";
        self.patient_address = @"";
        self.anamnesis = @"";
        self.nickName = @"";
        
    }
    return self;
}
+ (Patient *)patientWithMixResult:(FMResultSet *)result{
    Patient * patient = [[Patient alloc]init];
    patient.ckeyid = [result stringForColumn:@"ckeyid"];
    patient.patient_name = [result stringForColumn:@"patient_name"];
    patient.patient_phone = [result stringForColumn:@"patient_phone"];
    patient.patient_status = [result intForColumn:@"patient_status"];
    patient.intr_name = [result stringForColumn:@"intr_name"];
    patient.expense_num = [result intForColumn:@"expense_num"];
    patient.nickName = [result stringForColumn:@"nickName"];
    return patient;
}
+ (Patient *)patientlWithResult:(FMResultSet *)result {
    Patient * patient = [[Patient alloc]init];
    patient.ckeyid = [result stringForColumn:@"ckeyid"];
    patient.patient_name = [result stringForColumn:@"patient_name"];
    patient.patient_phone = [result stringForColumn:@"patient_phone"];
    patient.patient_avatar = [result stringForColumn:@"patient_avatar"];
    patient.patient_gender = [result stringForColumn:@"patient_gender"];
    patient.patient_age = [result stringForColumn:@"patient_age"];
    patient.patient_status = [result intForColumn:@"patient_status"];
    patient.introducer_id = [result stringForColumn:@"introducer_id"];
    patient.ori_user_id = [result stringForColumn:@"ori_user_id"];
    patient.user_id = [result stringForColumn:@"user_id"];
    patient.sync_time = [result stringForColumn:@"sync_time"];
    patient.doctor_id = [result stringForColumn:@"doctor_id"];
    patient.intr_name = [result stringForColumn:@"intr_name"];
    patient.creation_date = [result stringForColumn:@"creation_date"];
    
    patient.patient_allergy = [result stringForColumn:@"patient_allergy"];
    patient.patient_remark = [result stringForColumn:@"patient_remark"];
    patient.idCardNum = [result stringForColumn:@"IdCardNum"];
    patient.patient_address = [result stringForColumn:@"patient_address"];
    patient.anamnesis = [result stringForColumn:@"Anamnesis"];
    patient.nickName = [result stringForColumn:@"NickName"];
    
    return patient;
}

+ (NSString *)statusStrWithIntegerStatus:(PatientStatus)status {
    switch (status) {
        case PatientStatusUntreatment:
            return Untreatment;
            break;
        case PatientStatusUnplanted:
            return Unplanted;
            break;
        case PatientStatusUnrepaired:
            return Unrepaired;
            break;
        case PatientStatusRepaired:
            return Repaired;
            break;
        default:
            return OtherStr;
            break;
    }
}

+ (UIColor *)statusColorWithIntegerStatus:(PatientStatus)status{
    UIColor *color = [UIColor blackColor];
    switch (status) {
        case PatientStatusUntreatment:
            color = [UIColor colorWithHex:0x00a0ea];
            break;
        case PatientStatusUnplanted:
            color = [UIColor colorWithHex:0xff3b31];
            break;
        case PatientStatusUnrepaired:
            color = [UIColor colorWithHex:0x37ab4e];
            break;
        case PatientStatusRepaired:
            color = [UIColor colorWithHex:0x888888];
            break;
        default:
            break;
    }
    return color;
}

+ (Patient *)PatientFromPatientResult:(NSDictionary *)pat {
    
    Patient *tmpPatient = [[Patient alloc]init];
    
    tmpPatient.ckeyid = [pat stringForKey:@"ckeyid"];
    tmpPatient.patient_name = [pat stringForKey:@"patient_name"];
    tmpPatient.patient_phone = [pat stringForKey:@"patient_phone"];
    tmpPatient.patient_avatar = [pat stringForKey:@"patient_avatar"];
    tmpPatient.patient_gender = [pat stringForKey:@"patient_gender"];
    tmpPatient.patient_age = [pat stringForKey:@"patient_age"];
    tmpPatient.patient_status = [[pat stringForKey:@"patient_status"] integerValue];
    tmpPatient.introducer_id = [[pat stringForKey:@"introducer_id"] convertIfNill];
    tmpPatient.ori_user_id = [pat stringForKey:@"ori_doctor_id"];
   // tmpPatient.update_date = [NSString defaultDateString];
    tmpPatient.sync_time = [pat stringForKey:@"sync_time"];
    tmpPatient.doctor_id = [pat stringForKey:@"doctor_id"];
    tmpPatient.user_id = [AccountManager currentUserid];
    tmpPatient.intr_name = [pat stringForKey:@"intr_name"];
    tmpPatient.update_date = [pat stringForKey:@"update_time"];
    tmpPatient.creation_date = [pat stringForKey:@"creation_time"];
    tmpPatient.patient_allergy = [pat stringForKey:@"patient_allergy"];
    tmpPatient.patient_remark =[pat stringForKey:@"patient_remark"];
    tmpPatient.idCardNum = [pat stringForKey:@"IdCardNum"];
    tmpPatient.patient_address = [pat stringForKey:@"patient_address"];
    tmpPatient.anamnesis = [pat stringForKey:@"Anamnesis"];
    tmpPatient.nickName = [pat stringForKey:@"NickName"];
    
    return tmpPatient;
}

@end

@implementation Introducer

- (id)init {
    self = [super init];
    if (self) {
        self.intr_name = @"";
        self.intr_phone = @"";
    }
    return self;
}

+(Introducer *)intoducerFromIntro:(Introducer *)intro {
    Introducer *introducer = [[Introducer alloc]init];
    introducer.ckeyid = intro.ckeyid;
    introducer.intr_name = intro.intr_name;
    introducer.intr_phone = intro.intr_phone;
    introducer.intr_phone = intro.intr_phone;
    introducer.user_id = intro.user_id;
    introducer.creation_date = intro.creation_date;
    introducer.sync_time = intro.sync_time;
    introducer.update_date = intro.update_date;
    introducer.doctor_id = intro.doctor_id;
    introducer.intr_id = intro.intr_id;
    return introducer;
}
+ (Introducer *)introducerlWithResult:(FMResultSet *)result {
    Introducer * introducer = [[Introducer alloc]init];
    introducer.ckeyid = [result stringForColumn:@"ckeyid"];
    introducer.sync_time = [result stringForColumn:@"sync_time"];
    introducer.intr_name = [result stringForColumn:@"intr_name"];
    introducer.intr_phone = [result stringForColumn:@"intr_phone"];
    introducer.intr_id = [result stringForColumn:@"intr_id"];
    introducer.intr_level = [result intForColumn:@"intr_level"];
    introducer.creation_date = [result stringForColumn:@"creation_date"];
    introducer.update_date = [result stringForColumn:@"update_date"];
    introducer.user_id = [result stringForColumn:@"user_id"];
    introducer.doctor_id = [result stringForColumn:@"doctor_id"];
    return introducer;
}

+(Introducer *)IntroducerFromIntroducerResult:(NSDictionary *)inte {

    Introducer *tmpIntroducer = [[Introducer alloc]init];

    tmpIntroducer.ckeyid = [inte stringForKey:@"ckeyid"];
    tmpIntroducer.user_id = [AccountManager currentUserid];
    tmpIntroducer.sync_time = [inte stringForKey:@"sync_time"];
    tmpIntroducer.intr_name = [inte stringForKey:@"intr_name"];
    tmpIntroducer.intr_phone = [inte stringForKey:@"intr_phone"];
    tmpIntroducer.intr_level = [[inte stringForKey:@"intr_level"] integerValue];
    tmpIntroducer.sync_time = [inte stringForKey:@"sync_time"];
    tmpIntroducer.update_date = [NSString defaultDateString];
    tmpIntroducer.doctor_id = [inte stringForKey:@"doctor_id"];
    // 客户端缺少inter_id字段
    tmpIntroducer.intr_id = [inte stringForKey:@"intr_id"];
    return tmpIntroducer;
}

@end

@implementation Doctor

- (id)init {
    self = [super init];
    if (self) {
        _doctor_dept = @"";
        _doctor_phone = @"";
        _doctor_hospital = @"";
        _doctor_degree = @"";
        _doctor_email = @"";
        _doctor_position = @"";
        _doctor_image = @"";
        _auth_text = @"";
        _auth_pic = @"";
        _doctor_certificate = @"";
        _doctor_birthday = @"";
        _doctor_cv = @"";
        _doctor_skill = @"";
        _doctor_gender = @"";
    }
    return self;
}

/*
 doctor_id text, doctor_name text, doctor_dept text,doctor_phone text, user_id text, doctor_email text, doctor_hospital text, doctor_position text, doctor_degree text, auth_status integer, auth_text text, auth_pic text,creation_date text, update_date text
 */
+ (Doctor *)doctorlWithResult:(FMResultSet *)result {
    Doctor *doctor = [[Doctor alloc]init];
    doctor.ckeyid = [result stringForColumn:@"ckeyid"];
    doctor.doctor_name = [result stringForColumn:@"doctor_name"];
    doctor.doctor_dept = [result stringForColumn:@"doctor_dept"];
    doctor.doctor_phone = [result stringForColumn:@"doctor_phone"];
    doctor.user_id = [result stringForColumn:@"user_id"];
    doctor.doctor_email = [result stringForColumn:@"doctor_email"];
    doctor.doctor_hospital = [result stringForColumn:@"doctor_hospital"];
    doctor.doctor_position = [result stringForColumn:@"doctor_position"];
    doctor.doctor_degree = [result stringForColumn:@"doctor_degree"];
    doctor.doctor_image = [result stringForColumn:@"doctor_image"];
    doctor.auth_status = [result intForColumn:@"auth_status"];
    doctor.auth_text = [result stringForColumn:@"auth_text"];
    doctor.auth_pic = [result stringForColumn:@"auth_pic"];
    doctor.doctor_certificate = [result stringForColumn:@"doctor_certificate"];
    doctor.isopen = [result boolForColumn:@"isopen"];
    doctor.creation_date = [result stringForColumn:@"creation_date"];
    doctor.update_date = [result stringForColumn:@"update_date"];
    doctor.sync_time = [result stringForColumn:@"sync_time"];
    doctor.doctor_id = [result stringForColumn:@"doctor_id"];
    
    doctor.doctor_birthday = [result stringForColumn:@"doctor_birthday"];
    doctor.doctor_gender = [result stringForColumn:@"doctor_gender"];
    doctor.doctor_cv = [result stringForColumn:@"doctor_cv"];
    doctor.doctor_skill = [result stringForColumn:@"doctor_skill"];
    return doctor;
}

+ (Doctor *)DoctorFromDoctorResult:(NSDictionary *)dic {
    Doctor *tmpDoctor = [[Doctor alloc]init];
    tmpDoctor.ckeyid = [dic stringForKey:@"doctor_id"];
    tmpDoctor.creation_date = [dic stringForKey:@"creation_time"];
    tmpDoctor.doctor_certificate = [dic stringForKey:@"doctor_certificate"];
    tmpDoctor.doctor_name = [dic stringForKey:@"doctor_name"];
    tmpDoctor.doctor_phone = [dic stringForKey:@"doctor_phone"];
    tmpDoctor.doctor_position = [dic stringForKey:@"doctor_position"];
    tmpDoctor.doctor_degree = [dic stringForKey:@"doctor_degree"];
    tmpDoctor.doctor_image = [dic stringForKey:@"doctor_image"];
    tmpDoctor.doctor_dept = [dic stringForKey:@"doctor_dept"];
    tmpDoctor.doctor_hospital = [dic stringForKey:@"doctor_hospital"];
    tmpDoctor.auth_status = [dic integerForKey:@"doctor_is_verified"];
    tmpDoctor.auth_text = [dic stringForKey:@"doctor_verify_reason"];
    tmpDoctor.isopen = [dic integerForKey:@"is_open"];
    tmpDoctor.sync_time =[dic stringForKey:@"sync_time"];
    tmpDoctor.doctor_email = @"";
    tmpDoctor.auth_pic = @"";
    tmpDoctor.update_date = [NSString defaultDateString];
    tmpDoctor.doctor_id = [dic stringForKey:@"doctor_id"];
    tmpDoctor.user_id = [AccountManager currentUserid];
    
    tmpDoctor.isExist = [dic integerForKey:@"is_exists"];
    
    tmpDoctor.doctor_birthday = [dic stringForKey:@"doctor_birthday"];
    tmpDoctor.doctor_gender = [dic stringForKey:@"doctor_gender"];
    tmpDoctor.doctor_cv = [dic stringForKey:@"doctor_cv"];
    tmpDoctor.doctor_skill = [dic stringForKey:@"doctor_skill"];
    
    return tmpDoctor;
}

+ (Doctor *)DoctorWithPatientCountFromDoctorResult:(NSDictionary *)dic{
    Doctor *tmpDoctor = [[Doctor alloc]init];
    tmpDoctor.ckeyid = [dic stringForKey:@"doctor_id"];
    tmpDoctor.creation_date = [dic stringForKey:@"creation_time"];
    tmpDoctor.doctor_certificate = [dic stringForKey:@"doctor_certificate"];
    tmpDoctor.doctor_name = [dic stringForKey:@"doctor_name"];
    tmpDoctor.doctor_phone = [dic stringForKey:@"doctor_phone"];
    tmpDoctor.doctor_position = [dic stringForKey:@"doctor_position"];
    tmpDoctor.doctor_degree = [dic stringForKey:@"doctor_degree"];
    tmpDoctor.doctor_image = [dic stringForKey:@"doctor_image"];
    tmpDoctor.doctor_dept = [dic stringForKey:@"doctor_dept"];
    tmpDoctor.doctor_hospital = [dic stringForKey:@"doctor_hospital"];
    tmpDoctor.auth_status = [dic integerForKey:@"doctor_is_verified"];
    tmpDoctor.auth_text = [dic stringForKey:@"doctor_verify_reason"];
    tmpDoctor.isopen = [dic integerForKey:@"is_open"];
    tmpDoctor.sync_time =[dic stringForKey:@"sync_time"];
    tmpDoctor.doctor_email = @"";
    tmpDoctor.auth_pic = @"";
    tmpDoctor.update_date = [NSString defaultDateString];
    tmpDoctor.doctor_id = [dic stringForKey:@"doctor_id"];
    tmpDoctor.user_id = [AccountManager currentUserid];
    
    tmpDoctor.doctor_birthday = [dic stringForKey:@"doctor_birthday"];
    tmpDoctor.doctor_gender = [dic stringForKey:@"doctor_gender"];
    tmpDoctor.doctor_cv = [dic stringForKey:@"doctor_cv"];
    tmpDoctor.doctor_skill = [dic stringForKey:@"doctor_skill"];
    
    tmpDoctor.patient_count = [dic stringForKey:@"patient_count"];
    return tmpDoctor;
}

@end

@implementation RepairDoctor

+ (RepairDoctor *)repairDoctorlWithResult:(FMResultSet *)result {
    RepairDoctor *doctor = [[RepairDoctor alloc]init];
    doctor.ckeyid = [result stringForColumn:@"ckeyid"];
    doctor.doctor_name = [result stringForColumn:@"doctor_name"];
    doctor.doctor_phone = [result stringForColumn:@"doctor_phone"];
    doctor.user_id = [result stringForColumn:@"user_id"];
    doctor.creation_date = [result stringForColumn:@"creation_time"];
    doctor.sync_time = [result stringForColumn:@"sync_time"];
    doctor.doctor_id = [result stringForColumn:@"doctor_id"];
    doctor.data_flag  = [result stringForColumn:@"data_flag"];
    //doctor.update_date = [result stringForColumn:@"update_date"];
    doctor.creation_time = [result stringForColumn:@"creation_time"];
    return doctor;
}

+ (RepairDoctor *)repairDoctorFromDoctorResult:(NSDictionary *)dic {
    RepairDoctor *tmpDoctor = [[RepairDoctor alloc]init];
    tmpDoctor.ckeyid = [dic stringForKey:@"ckeyid"];
    tmpDoctor.creation_date = [dic stringForKey:@"creation_time"];
    tmpDoctor.doctor_name = [dic stringForKey:@"doctor_name"];
    tmpDoctor.doctor_phone = [dic stringForKey:@"doctor_phone"];
    tmpDoctor.sync_time =[dic stringForKey:@"sync_time"];
    tmpDoctor.doctor_id = [dic stringForKey:@"doctor_id"];
    tmpDoctor.user_id = [AccountManager currentUserid];
    tmpDoctor.data_flag = [dic stringForKey:@"data_flag"];
    tmpDoctor.update_date = [NSString defaultDateString];
    tmpDoctor.creation_time = [dic stringForKey:@"creation_time"];
    return tmpDoctor;
}

@end

@implementation CTLib

- (id)init {
    self = [super init];
    if (self) {
        self.ct_image = @"";
        self.ct_desc = @"";
        self.creation_date = @"";
    }
    return self;
}

- (NSString *)ct_image_detailUrl{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", uploadUrl, self.ckeyid, self.ct_image];
    return urlImage;
}

+(CTLib *)libWithResult:(FMResultSet *)result {
    // \"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"ct_image\" text,\n\t \"ct_desc\" text,\n\t \"creation_date\" text"];
    CTLib *lib = [[CTLib alloc]init];
    lib.ckeyid = [result stringForColumn:@"ckeyid"];
    lib.sync_time = [result stringForColumn:@"sync_time"];
    lib.case_id = [result stringForColumn:@"case_id"];
    lib.patient_id = [result stringForColumn:@"patient_id"];
    lib.ct_image = [result stringForColumn:@"ct_image"];
    lib.ct_desc = [result stringForColumn:@"ct_desc"];
    lib.update_date = [result stringForColumn:@"update_date"];
    lib.creation_date = [result stringForColumn:@"creation_date"];
    lib.user_id = [result stringForColumn:@"user_id"];
    lib.doctor_id = [result stringForColumn:@"doctor_id"];
    lib.creation_date_sync = [result stringForColumn:@"creation_date_sync"];
    lib.is_main = [result stringForColumn:@"is_main"];
    return lib;
}

+(CTLib *)CTLibFromCTLibResult:(NSDictionary *)medCT
{
    CTLib *templib = [[CTLib alloc]init];
    
    templib.ckeyid = [medCT stringForKey:@"ckeyid"];
    templib.case_id = [medCT stringForKey:@"case_id"];
    templib.ct_desc = [medCT stringForKey:@"ct_desc"];
    templib.ct_image = [medCT stringForKey:@"ct_image"];
    templib.user_id = [AccountManager currentUserid];
    templib.patient_id =[medCT stringForKey:@"patient_id"];
    templib.update_date = [NSString defaultDateString];
    templib.sync_time = [medCT stringForKey:@"sync_time"];
    templib.doctor_id = [medCT stringForKey:@"doctor_id"];
    templib.creation_date = [medCT stringForKey:@"creation_time"];
    templib.is_main = [medCT stringForKey:@"is_main"];
    
    return templib;
    
}

@end



@implementation PatientIntroducerMap

- (id)init {
    self = [super init];
    if (self) {
        self.patient_id = @"";
        self.remark = @"";
        self.sync_time = @"";
        self.update_date = @"";
        self.creation_date = @"";
    }
    return self;
}

+(PatientIntroducerMap *)patientIntroducerWithResult:(FMResultSet *)result{
    PatientIntroducerMap * map = [[PatientIntroducerMap alloc]init];
    map.ckeyid = [result stringForColumn:@"ckeyid"];
    map.sync_time = [result stringForColumn:@"sync_time"];
    map.intr_id = [result stringForColumn:@"intr_id"];
    map.intr_source = [result stringForColumn:@"intr_source"];
    map.intr_time = [result stringForColumn:@"intr_time"];
    map.remark = [result stringForColumn:@"remark"];
    map.patient_id = [result stringForColumn:@"patient_id"];
    map.creation_date = [result stringForColumn:@"creation_date"];
    map.update_date = [result stringForColumn:@"update_date"];
    map.user_id = [result stringForColumn:@"user_id"];
    map.doctor_id = [result stringForColumn:@"doctor_id"];
    
    return map;
}

+(PatientIntroducerMap *)PIFromMIResult:(NSDictionary *)mIRs{
    PatientIntroducerMap *tempMi = [[PatientIntroducerMap alloc] init];
    if (![[mIRs stringForKey:@"ckeyid"] isEmpty]) {
        tempMi.ckeyid = [mIRs stringForKey:@"ckeyid"];
    }
    tempMi.intr_id = [mIRs stringForKey:@"intr_id"];
    tempMi.intr_source = [mIRs stringForKey:@"intr_source"];
    tempMi.remark = [mIRs stringForKey:@"remark"];
    tempMi.user_id = [AccountManager currentUserid];
    tempMi.patient_id =[mIRs stringForKey:@"patient_id"];
    tempMi.update_date = [NSString defaultDateString];
    tempMi.sync_time = [mIRs stringForKey:@"sync_time"];
    tempMi.intr_time = [mIRs stringForKey:@"intr_time"];
    tempMi.doctor_id = [mIRs stringForKey:@"doctor_id"];
    
    return tempMi;
}
@end


@implementation MedicalRecord

- (id)init {
    self = [super init];
    if (self) {
        self.record_content = @"";
        self.creation_date = @"";
    }
    return self;
}

//"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"record_content\" text,\n\t \"creation_date\" text"];
+(MedicalRecord *)medicalRecordWithResult:(FMResultSet *)result {
    MedicalRecord *rec = [[MedicalRecord alloc]init];
    rec.ckeyid = [result stringForColumn:@"ckeyid"];
    rec.sync_time = [result stringForColumn:@"sync_time"];
    rec.patient_id = [result stringForColumn:@"patient_id"];
    rec.case_id = [result stringForColumn:@"case_id"];
    rec.record_content = [result stringForColumn:@"record_content"];
    rec.creation_date = [result stringForColumn:@"creation_date"];
    rec.update_date = [result stringForColumn:@"update_date"];
    rec.user_id = [result stringForColumn:@"user_id"];
    rec.doctor_id = [result stringForColumn:@"doctor_id"];
    rec.creation_date_sync = [result stringForColumn:@"creation_date_sync"];
    return rec;
}

+ (MedicalRecord *)MRFromMRResult:(NSDictionary *)medRe {
     MedicalRecord *tempRec = [[MedicalRecord alloc]init];
    
    tempRec.ckeyid = [medRe stringForKey:@"ckeyid"];
    tempRec.case_id = [medRe stringForKey:@"case_id"];
    tempRec.record_content = [medRe stringForKey:@"record_content"];
    tempRec.user_id = [AccountManager currentUserid];
    tempRec.patient_id =[medRe stringForKey:@"patient_id"];
    tempRec.update_date = [NSString defaultDateString];
    tempRec.sync_time = [medRe stringForKey:@"sync_time"];
    tempRec.doctor_id = [medRe stringForKey:@"doctor_id"];
    tempRec.creation_date = [medRe stringForKey:@"creation_time"];
    
    return tempRec;
}

@end

@implementation PatientConsultation

- (id)init {
    self = [super init];
    if (self) {
        self.cons_content = @"";
        self.creation_date = @"";
    }
    return self;
}

+(PatientConsultation *)patientConsultationWithResult:(FMResultSet *)result{
    PatientConsultation *pc = [[PatientConsultation alloc]init];
    pc.ckeyid = [result stringForColumn:@"ckeyid"];
    pc.patient_id = [result stringForColumn:@"patient_id"];
    pc.doctor_id = [result stringForColumn:@"doctor_id"];
    pc.doctor_name = [result stringForColumn:@"doctor_name"];
    pc.amr_file = [result stringForColumn:@"amr_file"];
    pc.amr_time = [result stringForColumn:@"amr_time"];
    pc.cons_type = [result stringForColumn:@"cons_type"];
    pc.cons_content = [result stringForColumn:@"cons_content"];
    pc.data_flag = [result intForColumn:@"data_flag"];
    pc.sync_time = [result stringForColumn:@"sync_time"];
    pc.creation_date = [result stringForColumn:@"creation_date"];
    pc.update_date = [result stringForColumn:@"update_date"];
    return pc;
}

+(PatientConsultation *)PCFromPCResult:(NSDictionary *)pat{
    PatientConsultation *tempPc = [[PatientConsultation alloc]init];
    tempPc.ckeyid = [pat stringForKey:@"ckeyid"];
    tempPc.patient_id = [pat stringForKey:@"patient_id"];
    tempPc.doctor_id = [pat stringForKey:@"doctor_id"];
    tempPc.doctor_name = [[pat stringForKey:@"doctor_name"] convertIfNill];
    tempPc.amr_file = [[pat stringForKey:@"amr_file"] convertIfNill];
    tempPc.amr_time = [[pat stringForKey:@"amr_time"] convertIfNill];
    tempPc.cons_type = [[pat stringForKey:@"cons_type"] convertIfNill];
    tempPc.cons_content = [[pat stringForKey:@"cons_content"] convertIfNill];
    tempPc.data_flag = [[pat stringForKey:@"data_flag"] integerValue];
    tempPc.sync_time = [pat stringForKey:@"sync_time"];
    tempPc.creation_date = [pat stringForKey:@"creation_time"];
    tempPc.update_date = [NSString defaultDateString];
    return tempPc;
}
@end

@implementation MedicalReserve

- (id)init {
    self = [super init];
    if (self) {
        self.reserve_time = @"";
        self.actual_time = @"";
        self.repair_time = @"";
        self.creation_date = @"";
    }
    return self;
}

+(MedicalReserve *)medicalReserveWithResult:(FMResultSet *)result {
    //\n\t \"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"reserve_time\" text,\n\t \"actual_time\" text,\n\t \"repair_time\" text,\n\t \"creation_date\" text"];
    
    MedicalReserve *reserve = [[MedicalReserve alloc]init];
    reserve.ckeyid = [result stringForColumn:@"ckeyid"];
    reserve.patient_id = [result stringForColumn:@"patient_id"];
    reserve.case_id = [result stringForColumn:@"case_id"];
    reserve.reserve_time = [result stringForColumn:@"reserve_time"];
    reserve.actual_time = [result stringForColumn:@"actual_time"];
    reserve.repair_time = [result stringForColumn:@"repair_time"];
    reserve.creation_date = [result stringForColumn:@"creation_date"];
    reserve.update_date = [result stringForColumn:@"update_date"];
    reserve.sync_time = [result stringForColumn:@"sync_time"];
    reserve.creation_date_sync = [result stringForColumn:@"creation_date_sync"];
    return reserve;
}

- (BOOL)hasActualDate  {
    if ([NSString isEmptyString:self.actual_time]) {
        return NO;
    }
    if ([self.actual_time isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}
- (BOOL)hasRepairDate {
    if ([NSString isEmptyString:self.repair_time]) {
        return NO;
    }
    if ([self.repair_time isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}
- (BOOL)hasRserveDate {
    if ([NSString isEmptyString:self.reserve_time]) {
        return NO;
    }
    if ([self.reserve_time isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

+(MedicalReserve *)MRSFromMRSResult:(NSDictionary *)medRs {
    MedicalReserve *reserve = [[MedicalReserve alloc]init];
    
    return reserve;
}

@end

@implementation UserObject

- (id)init {
    self = [super init];
    if (self) {
        self.authStatus = AuthStatusNotApply;
        self.name = @"";
        self.phone = @"";
        self.hospitalName = @"";
        self.department = @"";
        self.title = @"";
        self.degree = @"";
        self.userid = @"";
        self.authPic = @"";
        self.authText = @"";
        self.email = @"";
        self.accesstoken = @"";
        self.img = @"";
        
        
//        self.doctor_birthday = nil;
//        self.doctor_cv = nil;
//        self.doctor_gender = nil;
//        self.doctor_skill = nil;
    }
    return self;
}

+(UserObject *)userobjectWithResult:(FMResultSet *)result {
    UserObject *user = [[UserObject alloc]init];
    user.accesstoken = [result stringForColumn:@"accesstoken"];
    user.userid = [result stringForColumn:@"user_id"];
    user.name = [result stringForColumn:@"name"];
    user.phone = [result stringForColumn:@"phone"];
    user.email = [result stringForColumn:@"email"];
    user.hospitalName = [result stringForColumn:@"hospital_name"];
    user.department = [result stringForColumn:@"department"];
    user.title = [result stringForColumn:@"title"];
    user.degree = [result stringForColumn:@"degree"];
    user.authStatus = [result intForColumn:@"auth_status"];
    user.authText = [result stringForColumn:@"auth_text"];
    user.authPic = [result stringForColumn:@"auth_pic"];
    user.img = [result stringForColumn:@"img"];
    
    
    user.doctor_birthday = [result stringForColumn:@"doctor_birthday"];
    user.doctor_gender = [result stringForColumn:@"doctor_gender"];
    user.doctor_cv = [result stringForColumn:@"doctor_cv"];
    user.doctor_skill = [result stringForColumn:@"doctor_skill"];
    return user;
}

+ (NSString *)authStringWithStatus:(AuthStatus)status {
    switch (status) {
        case AuthStatusNotApply:
            return @"未认证";
            break;
        case AuthStatusInProgress:
            return @"认证中";
            break;
        case AuthStatusPassed:
            return @"已认证";
            break;
        case AuthStatusNotPass:
            return @"认证未通过";
            break;
        default:
            break;
    }
}

- (void)setUserObjectWithDic:(NSDictionary *)dic {
    self.userid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.accesstoken = [dic stringForKey:@"AccessToken" placeholder:@"accesstokenholder"];
    self.degree = [dic stringForKey:@"degree" placeholder:@"无"];
    self.email = [dic stringForKey:@"email" placeholder:@""];
    self.hospitalName = [dic stringForKey:@"hospital" placeholder:@"无"];
    self.authStatus = [dic integerForKey:@"isverified"];
    self.phone = [dic stringForKey:@"phone" placeholder:[dic stringForKey:@"mobile" placeholder:@""]];
    self.department = [dic stringForKey:@"postion" placeholder:@"无"];
    self.name = [dic stringForKey:@"username" placeholder:[dic stringForKey:@"name" placeholder:@""]];
    self.authText = [dic stringForKey:@"verifiedreason" placeholder:@"无"];
    self.img = [dic stringForKey:@"img" placeholder:@"无"];
    
#warning 添加新代码
    self.doctor_birthday = [dic stringForKey:@"doctor_birthday" placeholder:@""];
    self.doctor_gender = [dic stringForKey:@"doctor_gender" placeholder:@""];
    self.doctor_cv = [dic stringForKey:@"doctor_cv" placeholder:@""];
    self.doctor_skill = [dic stringForKey:@"doctor_skill" placeholder:@""];
}


+ (UserObject *)userobjectFromDic:(NSDictionary *)dic {
    UserObject *tmpDoctor = [[UserObject alloc]init];
    tmpDoctor.userid = [dic stringForKey:@"doctor_id"];
    tmpDoctor.authPic = [dic stringForKey:@"doctor_certificate"];
    tmpDoctor.name = [dic stringForKey:@"doctor_name"];
    tmpDoctor.phone = [dic stringForKey:@"doctor_phone"];
    tmpDoctor.title = [dic stringForKey:@"doctor_position"];
    tmpDoctor.degree = [dic stringForKey:@"doctor_degree"];
    tmpDoctor.department = [dic stringForKey:@"doctor_dept"];
    tmpDoctor.hospitalName = [dic stringForKey:@"doctor_hospital"];
    tmpDoctor.img = [dic stringForKey:@"doctor_image"];
    tmpDoctor.authStatus = [dic integerForKey:@"doctor_is_verified"];
    tmpDoctor.authText = [dic stringForKey:@"doctor_verify_reason"];
//    tmpDoctor. = [dic integerForKey:@"is_open"];
//    tmpDoctor.sync_time =[dic stringForKey:@"sync_time"];
//    tmpDoctor. =  [dic stringForKey:@"doctor_id"];
//    tmpDoctor.doctor_email = @"";
//    tmpDoctor.auth_pic = @"";
//    tmpDoctor.update_date = [NSString defaultDateString];
    
    tmpDoctor.doctor_birthday = [dic stringForKey:@"doctor_birthday"];
    tmpDoctor.doctor_gender = [dic stringForKey:@"doctor_gender"];
    tmpDoctor.doctor_cv = [dic stringForKey:@"doctor_cv"];
    tmpDoctor.doctor_skill = [dic stringForKey:@"doctor_skill"];
    return tmpDoctor;
}

@end

@implementation InfoAutoSync

+ (InfoAutoSync *)InfoAutoSyncWithResult:(FMResultSet *)result{
    InfoAutoSync *info = [[InfoAutoSync alloc]init];
    info.info_id = [result intForColumn:@"id"];
    info.data_type = [result stringForColumn:@"data_type"];
    info.post_type = [result stringForColumn:@"post_type"];
    info.dataEntity = [result stringForColumn:@"dataEntity"];
    info.sync_status = [result stringForColumn:@"sync_status"];
    info.autoSync_CreateDate = [result stringForColumn:@"autoSync_CreateDate"];
    info.syncCount = [result intForColumn:@"syncCount"];
    return info;
}


- (instancetype)initWithDataType:(NSString *)dataType postType:(NSString *)postType dataEntity:(NSString *)dataEntity syncStatus:(NSString *)syncStatus{
    InfoAutoSync *info = [[InfoAutoSync alloc] init];
    info.data_type = dataType;
    info.post_type = postType;
    info.dataEntity = dataEntity;
    info.sync_status = syncStatus;
    info.autoSync_CreateDate = [MyDateTool stringWithDateyyyyMMddHHmmss:[NSDate date]];
    info.syncCount = 0;
    return info;
}

@end


