//
//  News.m
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "News.h"

@implementation News

- (id)initWithObjects:(NSString *)newsId toTitle: (NSString *)title toUrl: (NSString *)url
{
    self = [super init];
    if (self) {
        _newsId = newsId;
        _title = title;
        _url = url;
    }
    return self;
}

@end
