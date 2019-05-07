//
//  JsonForBranchSearch.m
//  bdipo
//
//  Created by Nascenia on 4/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonForBranchSearch.h"
#import "ShowAlert.h"

@implementation JsonForBranchSearch
- (id)initWithBranchCredential:(NSString *)companyId code:(NSString *)bankCode
{
    self = [super init];
    if (self) {
        _companyId = companyId;
        _bankCode = bankCode;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
            _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        }else{
            _token = @"";
        }
    }
    return self;
}

-(NSDictionary *)createDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: _companyId forKey:@"company_id"];
    [dictionary setValue: _bankCode forKey:@"bank_code"];
    [dictionary setValue: _token forKey:@"auth_token"];
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

