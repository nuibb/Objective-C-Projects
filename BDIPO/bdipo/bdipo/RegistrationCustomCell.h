//
//  RegistrationCustomCell.h
//  bdipo
//
//  Created by Nascenia on 4/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol RegistrationViewDelegate;

@interface RegistrationCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

//@property (nonatomic, weak) IBOutlet id <RegistrationViewDelegate> delegate;

@end


#pragma mark -

/*
 Protocol to be adopted by the registration's delegate; the registration button tells its delegate if registered btn is clicked.
 */
/*@protocol RegistrationViewDelegate <NSObject>

@optional
- (void)goToPaymentSelection:(NSInteger)section;
@end*/
