//
//  SignUpCredentialsForTrialUser.h
//  bdipo
//
//  Created by Nascenia on 4/23/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpCredentialsForTrialUser : UITableViewHeaderFooterView
@property (nonatomic, strong) NSString *planType;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;

- (id)initWithSignUpCredentialsForTrialUser:(NSString *)planType toMail:(NSString *)email toName:(NSString *)fullName toPassword:(NSString *)password toConfirm:(NSString *)confirmPassword;
-(NSDictionary *)getDictionary;
@end
