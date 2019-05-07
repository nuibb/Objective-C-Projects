//
//  SignUpCredentials.h
//  bdipo
//
//  Created by Nascenia on 4/13/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpCredentials : NSObject
@property (nonatomic, strong) NSString *planType;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) NSString *paymentMethod;

- (id)initWithSignUpCredentials:(NSString *)planType toMail:(NSString *)email toName:(NSString *)fullName toPassword:(NSString *)password toConfirm:(NSString *)confirmPassword toPayment:(NSString *)paymentMethod;
-(NSDictionary *)getDictionary;
@end
