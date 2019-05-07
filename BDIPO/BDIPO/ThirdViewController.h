//
//  ThirdViewController.h
//  bdipo
//
//  Created by Nascenia on 3/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"

@interface ThirdViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SectionHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)loadSectionInfo:(NSDictionary *)sectionsInfoArray;
@end
