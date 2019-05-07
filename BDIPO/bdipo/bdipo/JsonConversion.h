//
//  JsonConversion.h
//  bdipo
//
//  Created by Nascenia on 4/13/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonConversion : NSObject
+ (NSData *) toJson:(NSDictionary *)data;
@end
