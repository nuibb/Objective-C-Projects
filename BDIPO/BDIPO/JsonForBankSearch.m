//
//  JsonForBankSearch.m
//  bdipo
//
//  Created by Nascenia on 3/31/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonForBankSearch.h"
#import "ShowAlert.h"

@implementation JsonForBankSearch
- (id)initWithBankCredential:(NSString *)companyId
{
    self = [super init];
    if (self) {
        _companyId = companyId;
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
