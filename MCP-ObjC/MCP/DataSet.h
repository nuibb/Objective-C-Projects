//
//  DataSet.h
//  MCP
//
//  Created by Nascenia on 5/28/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSet : NSObject

- (void) getCurrentLocation :(NSInteger)_id callback:(void(^)(NSDictionary *))handler;

@end
