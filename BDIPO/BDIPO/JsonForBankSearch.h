//
//  JsonForBankSearch.h
//  bdipo
//
//  Created by Nascenia on 3/31/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonForBankSearch : NSObject
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *token;
- (id)initWithBankCredential:(NSString *)companyId;
- (NSDictionary *) createDictionary;
- (NSData *) toJson;
@end
