//
//  News.h
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property NSString *newsId;
@property NSString *title;
@property NSString *url;
- (id)initWithObjects:(NSString *) newsId toTitle: (NSString *)title toUrl: (NSString *)url;
@end
