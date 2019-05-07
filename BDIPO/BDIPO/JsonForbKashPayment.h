//
//  JsonForbKashPayment.h
//  bdipo
//
//  Created by Nascenia on 4/20/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonForbKashPayment : NSObject
@property (nonatomic, strong) NSString *invoiceId;
@property (nonatomic, strong) NSString *transectionId;
@property (nonatomic, strong) NSString *paymentDate;
@property (nonatomic, strong) NSString *token;
- (id)initWithbKashCredential:(NSString *)invoiceId trId:(NSString *)transectionId date:(NSString *)paymentDate;
- (NSDictionary *) getDictionary;
@end
