//
//  UIApplication+Version.m
//  CRM
//
//  Created by TimTiger on 14-7-23.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "UIApplication+Version.h"

@implementation UIApplication (Version)

+ (NSString *)systemVersion{
    return [UIDevice currentDevice].systemVersion;
}


+ (NSString *)currentVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return currentVersion;
}

+ (void)checkNewVersionWithAppleID:(NSString *)appleid handler:(ApplicaionVersionHandler)handler {
    //https://itunes.apple.com/us/app/zhong-ya-guan-jia-kou-qiang/id901754828?mt=8&uo=4
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleid];//   901754828
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"POST"];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError != nil) {
                return;
            }
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error == nil) {
                NSArray *infoArray = [dic objectForKey:@"results"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([infoArray count]) {
                        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                        __block NSURL *updateURL = [NSURL URLWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                        if (NSOrderedDescending == [lastVersion localizedStandardCompare:currentVersion]) {
                            handler(YES,updateURL);
                        }
                        else
                        {
                            handler(NO,nil);
                        }
                    }
                });
            }
        }];
}

+ (void)updateApplicationWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}


@end
