//
//  RegistrationController.h
//  bdipo
//
//  Created by Nascenia on 4/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
//#import "RegistrationCustomCell.h"

@interface RegistrationController : UIViewController<UITableViewDataSource, UITableViewDelegate, SectionHeaderViewDelegate>//RegistrationViewDelegate

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
