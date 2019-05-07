//
//  GetServices.m
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "GetServices.h"
#import "CheckInternetConnection.h"
#import "ShowAlert.h"

@implementation GetServices

-(void)apiCallToGet:(NSString *)url callback: (void(^)(id))handler{
    if ([CheckInternetConnection connectedToNetwork]) {
        //NSLog(@"%@", url);
        if ([url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]) {
            [self request:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] callback:handler];
        }
    }else{
        [ShowAlert alertWithMessage:@"Warning!" message:@"Your Internet connection seems to be offline. Please connect your device to Internet."];
    }
}

-(void)request:(NSString *)url callback: (void(^)(id))handler{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL: [NSURL URLWithString:url]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            // handle response
                                            if (error != nil) {
                                                if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
                                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                                        [ShowAlert alertWithMessage:@"Warning!" message:[self showMsgToErrorDomain:error.code]];
                                                    });
                                                }
                                            }else{
                                                [self processResponseUsingData:data callback:handler];
                                            }
                                        }];
    [task resume];
}

-(void) processResponseUsingData:(NSData*)data callback: (void(^)(id))handler{
    NSError *parseJsonError = nil;
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseJsonError];
    
    if (!parseJsonError){
        handler(jsonDict);
    }else{
        // Update the UI on the main thread.
        dispatch_sync(dispatch_get_main_queue(), ^{
            [ShowAlert alertWithMessage:@"Warning!" message:[self showMsgToErrorDomain:parseJsonError.code]];
        });
    }
}

-(NSString *)showMsgToErrorDomain:(NSInteger)code{
    switch (code) {
        case -1000:
            return @"You are currently accessing with a bad url. Please check your domain server.";
        case -1001:
            return @"Request timeout. Please try again later.";
        case -1002:
            return @"You are currently accessing with a unsupported url. Please check your domain server.";
        case -1003:
            return @"Can not find the host server. Please try again later.";
        case -1004:
            return @"Can not connect to host server. Please try again later.";
        case -1005:
            return @"Your Internet connection is lost. Please try again later.";
        case -1006:
            return @"Can not find the host server. Please try again later.";
        case -1009:
            return @"Your Internet connection seems to be offline. Please connect your device to Internet.";
        case -1012:
            return @"Authenticaion failed. Please try again later.";
        case -1013:
            return @"Authenticaion failed. Please try again later.";
        default:
            return @"Something went wrong. Please try again later.";
    }
}

@end
