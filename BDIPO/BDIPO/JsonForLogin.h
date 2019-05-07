//
//  JsonForLogin.h
//  bdipo
//
//  Created by Nascenia on 3/31/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonForLogin : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
- (id)initWithLoginCredential:(NSString *)username toPassword: (NSString *)password;
- (NSDictionary *) createDictionary;
- (NSData *) toJson;
@end
