//
//  JsonForDBBLGateway.h
//  bdipo
//
//  Created by Nascenia on 4/20/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonForDBBLGateway : NSObject
@property (nonatomic, strong) NSString *paymentId;
@property (nonatomic, strong) NSString *provider;
- (id)initWithDBBLCredential:(NSString *)paymentId toProvider:(NSString *)provider;
- (NSDictionary *) getDictionary;
@end
