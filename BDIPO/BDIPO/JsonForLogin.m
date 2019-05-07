//
//  JsonForLogin.m
//  bdipo
//
//  Created by Nascenia on 3/31/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonForLogin.h"
#import "ShowAlert.h"

@implementation JsonForLogin
- (id)initWithLoginCredential:(NSString *)username toPassword: (NSString *)password
{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

-(NSDictionary *)createDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: _username forKey:@"username"];
    [dictionary setValue: _password forKey:@"password"];
    return dictionary;
}

-(NSData *)toJson{
    NSError *error = nil;
    NSDictionary *convertableData = self.createDictionary;
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:convertableData options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error != nil) {
       [ShowAlert alertWithMessage:@"Error!" message:error.localizedDescription];
    }else{
        //NSLog(@"%@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]);
        return json;
    }
    
    return nil;
}

@end
