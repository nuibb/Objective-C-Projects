//
//  JsonForBranchSearch.h
//  bdipo
//
//  Created by Nascenia on 4/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonForBranchSearch : NSObject
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *token;
- (id)initWithBranchCredential:(NSString *)companyId code:(NSString *)bankCode;
- (NSDictionary *) createDictionary;
- (NSData *) toJson;
@end
