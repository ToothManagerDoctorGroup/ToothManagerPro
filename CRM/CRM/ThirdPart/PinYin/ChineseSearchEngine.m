//
//  ChineseSearchEngine.m
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "ChineseSearchEngine.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "DBTableMode.h"
#import "IntroducerCellMode.h"
#import "PatientsCellMode.h"
#import "AddressBookViewController.h"
#import "DBTableMode.h"
#import "RepairDoctorCellMode.h"

@implementation ChineseSearchEngine


+ (NSArray *)resultArraySearchIntroducerOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText {
    NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:0];

    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<dataArray.count; i++) {
            IntroducerCellMode *mode = [dataArray objectAtIndex:i];
            if ([ChineseInclude isIncludeChineseInString:mode.name]) {
                
                if(searchText.length == 1){
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:mode.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchResults addObject:mode];
                    }
                }else{
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:mode.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:mode];
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:mode.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchResults addObject:mode];
                    }
                }
            }
            else {
                NSRange titleResult=[mode.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:mode];
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (IntroducerCellMode *tmpMode in dataArray) {
            
            NSRange titleResult=[tmpMode.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tmpMode];
            }
        }
    }
    
    return searchResults;
}


+ (NSArray *)resultArraySearchMaterialOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText {
        NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:0];
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<dataArray.count; i++) {
            Material *material = [dataArray objectAtIndex:i];
            if ([ChineseInclude isIncludeChineseInString:material.mat_name]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:material.mat_name];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:material];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:material.mat_name];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:material];
                }
            }
            else {
                NSRange titleResult=[material.mat_name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:material];
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (Material *tempMaterial in dataArray) {
            NSRange titleResult=[tempMaterial.mat_name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tempMaterial];
            }
        }
    }
    return searchResults;
}

+ (NSArray *)resultArraySearchPatientsOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText {
    NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:0];
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<dataArray.count; i++) {
            PatientsCellMode *patient = [dataArray objectAtIndex:i];
            if ([ChineseInclude isIncludeChineseInString:patient.name]) {
                if(searchText.length == 1){
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:patient.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchResults addObject:patient];
                    }
                }else{
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:patient.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:patient];
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:patient.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchResults addObject:patient];
                    }
                }
            }
            else {
                NSRange titleResult=[patient.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:patient];
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (PatientsCellMode *tmpPatient in dataArray) {
            NSRange titleResult=[tmpPatient.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tmpPatient];
            }
        }
    }
    return searchResults;
}

+ (NSArray *)resultArraySearchAddressBookOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText {
    NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:0];
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<dataArray.count; i++) {
            AddressBookCellMode *patient = [dataArray objectAtIndex:i];
            if ([ChineseInclude isIncludeChineseInString:patient.name]) {
                
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:patient.name];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:patient];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:patient.name];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:patient];
                }
            }
            else {
                NSRange titleResult=[patient.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:patient];
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (AddressBookCellMode *tmpPatient in dataArray) {
            NSRange titleResult=[tmpPatient.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tmpPatient];
            }
        }
    }
    return searchResults;
}

+ (NSArray *)resultArraySearchDoctorOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText {
    NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:0];
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<dataArray.count; i++) {
            Doctor *patient = [dataArray objectAtIndex:i];
            if ([ChineseInclude isIncludeChineseInString:patient.doctor_name]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:patient.doctor_name];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:patient];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:patient.doctor_name];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:patient];
                }
            }
            else {
                NSRange titleResult=[patient.doctor_name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:patient];
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (Doctor *tmpPatient in dataArray) {
            NSRange titleResult=[tmpPatient.doctor_name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tmpPatient];
            }
        }
    }
    return searchResults;
}

+ (NSArray *)resultArraySearchRepairDoctorOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText
{
    NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:0];
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<dataArray.count; i++) {
            BOOL isAdd = NO;
            RepairDoctorCellMode *repairDoctor = [dataArray objectAtIndex:i];
            if ([ChineseInclude isIncludeChineseInString:repairDoctor.name]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:repairDoctor.name];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    isAdd = YES;
                    [searchResults addObject:repairDoctor];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:repairDoctor.name];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0 && isAdd == NO) {
                    [searchResults addObject:repairDoctor];
                }
            }
            else {
                NSRange titleResult=[repairDoctor.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:repairDoctor];
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (RepairDoctorCellMode *tmprepairDoctor in dataArray) {
            NSRange titleResult=[tmprepairDoctor.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tmprepairDoctor];
            }
        }
    }
    return searchResults;
}

@end
