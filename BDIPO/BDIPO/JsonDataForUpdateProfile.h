//
//  JsonDataForUpdateProfile.h
//  bdipo
//
//  Created by Nascenia on 4/29/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonDataForUpdateProfile : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *secondaryMail;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *location;

- (id)initWithProfileCredential:(NSString *)name secMail:(NSString *)secondaryMail toPassword:(NSString *)password toConfirm:(NSString *)confirmPassword toSex:(NSString *)sex toPhone:(NSString *)phone toLocation:(NSString *)location;
- (NSDictionary *) getDictionary;

@end
