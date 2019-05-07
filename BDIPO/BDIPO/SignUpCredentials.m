//
//  SignUpCredentials.m
//  bdipo
//
//  Created by Nascenia on 4/13/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "SignUpCredentials.h"

@implementation SignUpCredentials
- (id)initWithSignUpCredentials:(NSString *)planType toMail:(NSString *)email toName:(NSString *)fullName toPassword:(NSString *)password toConfirm:(NSString *)confirmPassword toPayment:(NSString *)paymentMethod
{
    self = [super init];
    if (self) {
        _planType = planType;
        _email = email;
        _fullName = fullName;
        _password = password;
        _confirmPassword = confirmPassword;
        _paymentMethod = paymentMethod;
    }
    return self;
}

-(NSDictionary *) getDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: _planType forKey:@"pricing_plan_type"];
    [dictionary setValue: _email forKey:@"login"];
    [dictionary setValue: _fullName forKey:@"name"];
    [dictionary setValue: _password forKey:@"password"];
    [dictionary setValue: _confirmPassword forKey:@"password_confirmation"];
    [dictionary setValue: _paymentMethod forKey:@"initiated_method"];
    return dictionary;
}

@end
