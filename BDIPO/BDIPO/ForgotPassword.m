//
//  ForgotPassword.m
//  bdipo
//
//  Created by Nascenia on 4/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "ForgotPassword.h"
#import "Settings.h"
#import "GetServices.h"
#import "JsonConversion.h"
#import "ShowAlert.h"

@interface ForgotPassword ()
@property GetServices *getService;
@property Settings *settings;
@property NSMutableDictionary *dictionary;
@end

@implementation ForgotPassword

- (IBAction)btnEventListener:(id)sender {
    if (![_textField.text isEqualToString:@""]){
        _label.text = @"";
        [self.getService apiCallToGet:[self.settings isForgetPassword:_textField.text] callback:^(NSDictionary *response){
            if ([response[@"status"] isEqualToString:@"success"]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _label.text = @"Please check your email to reset your password.";
                    [_label setTextColor: [UIColor colorWithRed: 83.0f/255.0f green:80.0f/255.0f blue:162.0f/255.0f alpha:1.0]];
                });
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _label.text = @"You tried with an invalid user email.";
                    [_label setTextColor: [UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0]];
                });
            }
        }];
        
    }else{
        [ShowAlert alertWithMessage:@"Message!" message:@"Text field should not be empty."];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = [[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    _label.text = @"";
    
    self.settings = [[Settings alloc]init];
    self.getService = [[GetServices alloc]init];
    self.dictionary = [[NSMutableDictionary alloc] init];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
