//
//  JsonDataForUpdateProfile.m
//  bdipo
//
//  Created by Nascenia on 4/29/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonDataForUpdateProfile.h"

@implementation JsonDataForUpdateProfile

-(id)initWithProfileCredential:(NSString *)name secMail:(NSString *)secondaryMail toPassword:(NSString *)password toConfirm:(NSString *)confirmPassword toSex:(NSString *)sex toPhone:(NSString *)phone toLocation:(NSString *)location{
    
    self = [super init];
    if (self) {
        _name = name;
        _secondaryMail = secondaryMail;
        _password = password;
        _confirmPassword = confirmPassword;
        _sex = sex;
        _phone = phone;
        _location = location;
    }
    return self;
}


-(NSDictionary *)getDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (_name && ![_name isEqualToString:@""]) {
        [dictionary setValue: _name forKey:@"name"];
    }
    
    if (_secondaryMail && ![_secondaryMail isEqualToString:@""]) {
        [dictionary setValue: _secondaryMail forKey:@"secondary_email_address"];
    }
    
    if (_password && ![_password isEqualToString:@""]) {
        [dictionary setValue: _password forKey:@"password"];
    }
    
    if (_confirmPassword && ![_confirmPassword isEqualToString:@""]) {
        [dictionary setValue: _confirmPassword forKey:@"password_confirmation"];
    }
    
    if (_sex && ![_sex isEqualToString:@""]) {
        [dictionary setValue: _sex forKey:@"sex"];
    }
    
    if (_phone && ![_phone isEqualToString:@""]) {
        [dictionary setValue: _phone forKey:@"phone_number"];
    }
    
    if (_location && ![_location isEqualToString:@""]) {
        [dictionary setValue: _location forKey:@"location"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        [dictionary setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"auth_token"];
    }

    return dictionary;
}


@end
