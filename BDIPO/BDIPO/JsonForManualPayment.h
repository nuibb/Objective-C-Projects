//
//  JsonForManualPayment.h
//  bdipo
//
//  Created by Nascenia on 4/20/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonForManualPayment : NSObject
@property (nonatomic, strong) NSString *invoiceId;
@property (nonatomic, strong) NSString *branchName;
@property (nonatomic, strong) NSString *paymentMode;
@property (nonatomic, strong) NSString *paymentDate;
@property (nonatomic, strong) NSString *token;
- (id)initWithManualCredential:(NSString *)invoiceId branch:(NSString *)branchName mode:(NSString *)paymentMode date:(NSString *)paymentDate;
- (NSDictionary *) getDictionary;
@end
