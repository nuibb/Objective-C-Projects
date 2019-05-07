//
//  ForgotPassword.h
//  bdipo
//
//  Created by Nascenia on 4/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPassword : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@end
