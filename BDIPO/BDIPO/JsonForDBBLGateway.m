//
//  JsonForDBBLGateway.m
//  bdipo
//
//  Created by Nascenia on 4/20/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "JsonForDBBLGateway.h"

@implementation JsonForDBBLGateway

- (id)initWithDBBLCredential:(NSString *)paymentId toProvider:(NSString *)provider
{
    self = [super init];
    if (self) {
        _paymentId = paymentId;
        _provider = provider;
    }
    return self;
}

-(NSDictionary *)getDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: _paymentId forKey:@"payment_id"];
    [dictionary setValue: _provider forKey:@"provider"];
    return dictionary;
}

@end
