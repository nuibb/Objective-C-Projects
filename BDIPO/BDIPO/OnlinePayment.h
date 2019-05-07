//
//  OnlinePayment.h
//  bdipo
//
//  Created by Nascenia on 4/17/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlinePayment : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *paymentId;
@end
