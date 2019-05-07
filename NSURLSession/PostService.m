//
//  PostService.m
//  bdipo
//
//  Created by Nascenia on 3/31/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "PostService.h"
#import "CheckInternetConnection.h"
#import "ShowAlert.h"

@implementation PostService

-(void)apiCallToPost:(NSString *)url serializedData: data callback:(void (^)(NSDictionary *))handler{
    if ([CheckInternetConnection connectedToNetwork]) {
        //NSLog(@"%@", url);
        if ([url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]) {
            [self request:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] serializedData:data callback:handler];
        }
    }else{
        [ShowAlert alertWithMessage:@"Warning!" message:@"Your Internet connection seems to be offline. Please connect your device to Internet."];
    }
}

-(void)request:(NSString *)url serializedData: data callback: (void(^)(NSDictionary *))handler{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //Validating basic authentication
    NSString *authStr = @"test:testnascenia";
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        if (error != nil) {
            //NSLog(@"%@", [error localizedDescription]);
            if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [ShowAlert alertWithMessage:@"Warning!" message:[self showMsgToErrorDomain:error.code]];
                });
            }
        }else{
            //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self processResponseUsingData:data callback:handler];
        }
    }];
    
    [task resume];
}

-(void) processResponseUsingData:(NSData*)data callback: (void(^)(NSDictionary *))handler{
    NSError *parseJsonError = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseJsonError];
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

