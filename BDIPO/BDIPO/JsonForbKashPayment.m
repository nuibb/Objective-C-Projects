//
//  JsonForbKashPayment.m
//  bdipo
//
//  Created by Nascenia on 4/20/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonForbKashPayment.h"

@implementation JsonForbKashPayment

- (id)initWithbKashCredential:(NSString *)invoiceId trId:(NSString *)transectionId date:(NSString *)paymentDate
{
    self = [super init];
    if (self) {
        _invoiceId = invoiceId;
        _transectionId = transectionId;
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
    [dictionary setValue: _transectionId forKey:@"bkash_transection_id"];
    [dictionary setValue: _paymentDate forKey:@"payment_date"];
    [dictionary setValue: _token forKey:@"auth_token"];
    return dictionary;
}

@end
