//
//  RegisterWithPayment.h
//  bdipo
//
//  Created by Nascenia on 4/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterWithPayment : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *fullname;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *retypePassword;
@property (weak, nonatomic) IBOutlet UILabel *staticText;
@property (weak, nonatomic) IBOutlet UITextField *choosePlan;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *paymentText;
@property NSString *planType;
@property BOOL isTrialAccount;
@end
