//
//  JsonForManualPayment.m
//  bdipo
//
//  Created by Nascenia on 4/20/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonForManualPayment.h"

@implementation JsonForManualPayment

- (id)initWithManualCredential:(NSString *)invoiceId branch:(NSString *)branchName mode:(NSString *)paymentMode date:(NSString *)paymentDate
{
    self = [super init];
    if (self) {
        _invoiceId = invoiceId;
        _branchName = branchName;
        _paymentMode = paymentMode;
        _paymentDate = paymentDate;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
            _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        }else{
            _token = @"";
        }
    }
    return self;
}

-(NSDictionary *)getDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: _invoiceId forKey:@"invoice_id"];
    [dictionary setValue: _branchName forKey:@"branch_name"];
    [dictionary setValue: _paymentMode forKey:@"payment_mode"];
    [dictionary setValue: _paymentDate forKey:@"payment_date"];
    [dictionary setValue: _token forKey:@"auth_token"];
    return dictionary;
}

@end
