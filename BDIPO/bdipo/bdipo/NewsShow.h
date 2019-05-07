//
//  NewsShow.h
//  bdipo
//
//  Created by Nascenia on 3/9/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface NewsShow : UIViewController<UIWebViewDelegate>
@property (nonatomic, strong) NSString *cName;
@property (nonatomic, strong) NSString *url;
@end
