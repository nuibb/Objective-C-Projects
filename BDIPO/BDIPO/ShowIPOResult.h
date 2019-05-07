//
//  ShowIPOResult.h
//  bdipo
//
//  Created by Nascenia on 3/11/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowIPOResultHeaderCell.h"
#import "ShowIPOResultCustomCell.h"

@interface ShowIPOResult : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *cName;
@property (nonatomic, strong) NSString *descText;
@property NSMutableArray *searchResult;
@end
