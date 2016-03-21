//
//  NetworkConfigMacro.h
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#ifndef NetworkConfigMacro_h
#define NetworkConfigMacro_h

// 域名
#define DomainName @"http://122.114.62.57/"

//#define DomainName @"http://118.244.234.207/"

#define Method_His_Crm @"his.crm"
#define Method_Weixin @"NewWeixin"
#define Method_ClinicServer @"clinicServer"
#define Method_Sys @"sys"

#define RealURL(path,method) [NSString stringWithFormat:"@%@%@/ashx/%@",DomainName,method,path]
//////////////////////////////////////////////////////////////////////
//                           团队协作                                //
//////////////////////////////////////////////////////////////////////
//病历相关基本接口
#define QueryMedicalCaseBaseUrl  RealURL("MedicalCaseHandler.ashx",Method_His_Crm)
//治疗团队基本接口
#define TreateTeamBaseUrl  RealURL(CureTeamHandler.ashx,Method_His_Crm)
//治疗方案基本接口
#define TreatePlanBaseUrl  RealURL(CureProjectHandler.ashx,Method_His_Crm)
//病程记录
#define DiseaseRecordBaseUrl  RealURL(MedicalCourseHandler.ashx,Method_His_Crm)
//耗材使用
#define MedicalExpenseBaseUrl  RealURL(MedicalExpenseHandler.ashx,Method_His_Crm)
//我的好友
#define MyFriendBaseUrl  RealURL(PatientIntroducerMapHandler.ashx,Method_His_Crm)
//金币
#define GoldRecordBaseUrl  RealURL(GoldRecordHandler.ashx,Method_His_Crm)
//积分
#define ScoreRecordBaseUrl  RealURL(ScoreRecordHandler.ashx,Method_His_Crm)

#endif /* NetworkConfigMacro_h */
