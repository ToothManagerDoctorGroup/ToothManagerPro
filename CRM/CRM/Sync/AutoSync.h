//
//  AutoSync.h
//  CRM
//
//  Created by Argo Zhang on 15/12/17.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#ifndef AutoSync_h
#define AutoSync_h

//Data_Type
#define AutoSync_Patient @"patient" //患者
#define AutoSync_Material @"material"//材料
#define AutoSync_Introducer @"introducer"//介绍人
#define AutoSync_MedicalCase @"medicalcase"//病历
#define AutoSync_CtLib @"ctlib"//ct片
#define AutoSync_MedicalExpense @"medicalexpense"//耗材
#define AutoSync_MedicalRecord @"medicalrecord"//病情描述
#define AutoSync_ReserveRecord @"reserverecord"//预约
#define AutoSync_PatientConsultation @"patientconsultation"//会诊信息
#define AutoSync_PatientIntroducerMap @"pintromap"//关系表
#define AutoSync_Friend @"repairdoctor" //医生好友
#define AutoSync_Transfer @"transfer"   //转诊

#define AutoSync_RepairDoctor @"AutoSync_RepairDoctor"
#define AutoSync_WeiXinMessageSend @"AutoSync_WeiXinMessageSend"
#define AutoSync_ReserveRecord_ForOther @"AutoSync_ReserveRecord_ForOther"
#define AutoSync_AddPatientToGroups @"AutoSync_AddPatientToGroups"

//Post_type
#define Update @"edit"
#define Delete @"delete"
#define Insert @"add"
#define UpdateReserveStatus @"updatereservestatus"

//行为表同步时间
#define AutoSync_Behaviour_SyncTime [NSString stringWithFormat:@"AutoSync_Behaviour_SyncTime_%@",[AccountManager currentUserid]]

#endif /* AutoSync_h */
