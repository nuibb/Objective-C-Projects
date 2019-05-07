//
//  JsonConversion.m
//  bdipo
//
//  Created by Nascenia on 4/13/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonConversion.h"
#import "ShowAlert.h"

@implementation JsonConversion

+(NSData *)toJson:(NSDictionary *)data{
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error != nil) {
        [ShowAlert alertWithMessage:@"Error!" message:error.localizedDescription];
    }else{
        //NSLog(@"%@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]);
        return json;
    }
    
    return nil;
}

@end
