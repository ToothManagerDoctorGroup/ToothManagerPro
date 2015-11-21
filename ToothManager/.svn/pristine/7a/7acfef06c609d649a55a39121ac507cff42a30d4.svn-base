//
//  NetworkConfigHeader.h
//  ToothManager
//

#ifndef ToothManager_NetworkConfigHeader_h
#define ToothManager_NetworkConfigHeader_h

// 错误提示信息
#define NetError @"网络异常"
#define UnknownError @"未知异常"

// 域名
#define DomainName @"http://122.114.62.57/"
#define NetworkPrefix @"http://122.114.62.57/clinicServer/ashx/"

#define RealURL(path)    [NetworkPrefix stringByAppendingString:@(path)]

////////////////////////////////////////////////////////////////////////////////
//                               登录，忘记密码                                 //
////////////////////////////////////////////////////////////////////////////////
// 登录、修改登录密码、忘记密码、获取验证码
#define UserURL                         RealURL("SysUserHandler.ashx")


////////////////////////////////////////////////////////////////////////////////
//                               我的                                         //
////////////////////////////////////////////////////////////////////////////////
// 修改支付密码
#define UpdatePayPasswordURL            RealURL("ClinicHandler.ashx")

// 查看椅位配图
#define QueryScheduleChairImageListURL       RealURL("SeatImgInfoHandler.ashx")

// 查看诊所基本信息
#define QueryClinicDetailURL            RealURL("ClinicHandler.ashx")

// 查看诊所数据汇总信息
#define QueryClinicSummaryURL           RealURL("ClinicSummaryHandler.ashx")

// 查看诊所银行卡信息
#define QueryClinicBankURL              RealURL("ClinicBankHandler.ashx")

// 查看诊所账户信息
#define QueryClinicAccountURL           RealURL("ClinicAccountHandler.ashx")

// 查看实景图
#define QueryRealisticlURL              RealURL("ClinicInfoHandler.ashx")

// 账户余额提现
#define AccountGetCashURL               RealURL("ClinicBankHandler.ashx")

// 查看我的收入列表
#define QueryIncomeListURL              RealURL("IncomeHandler.ashx")

// 查看消息中心列表、按状态查看消息中心列表,查询看消息条数
#define QueryMessageListURL             RealURL("MessageHandler.ashx")

// 查看提现记录
#define QueryWithdrawRecordListURL      RealURL("WithdrawLogHandler.ashx")

// 查询助手列表
#define QueryAssistListURL              RealURL("AssistantHandler.ashx")

// 查询材料列表
#define QueryMaterialListURL            RealURL("MaterialHandler.ashx")

////////////////////////////////////////////////////////////////////////////////
//                               日程表                                        //
////////////////////////////////////////////////////////////////////////////////
// 查看日程信息列表、查看某个椅位的日程信息列表
// 查看全部预约信息、按状态查看我的预约信息
// 按椅位查看我的预约信息、查看预约详情
#define QueryScheduleListURL            RealURL("AppointmentsHandler.ashx")

// 查看日程椅位信息
#define QueryScheduleChairListURL       RealURL("SeatHandler.ashx")


////////////////////////////////////////////////////////////////////////////////
//                               待办项                                        //
////////////////////////////////////////////////////////////////////////////////
// 查看待办事项列表
#define QueryGtaskListURL               RealURL("SignInfoHandler.ashx")

// 显示详细签约信息
#define QueryContractDetailURL          RealURL("SignInfoHandler.ashx")

// 接受签约信息, // 拒绝签约信息
#define ContractURL                     RealURL("ClinicDoctorMapHandler.ashx")


////////////////////////////////////////////////////////////////////////////////
//                               医生库                                        //
////////////////////////////////////////////////////////////////////////////////
// 查看医生信息列表, 查看医生详情
#define QueryDoctorListURL              RealURL("DoctorHandler.ashx")

#endif
