//
//  LoginViewController.m
//  bdipo
//
//  Created by Nascenia on 3/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "LoginViewController.h"
#import "PostService.h"
#import "Settings.h"
#import "JsonForLogin.h"
#import "ShowAlert.h"

@interface LoginViewController ()
@property PostService *postService;
@property Settings *settings;
@property JsonForLogin *dataSerialization;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *registrationBtn;

@end

@implementation LoginViewController

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)logInBtnEventListener:(id)sender {
    //Get authentication token by login
    if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        if ([self isValidEmail:self.username.text]) {
            self.dataSerialization = [[JsonForLogin alloc] initWithLoginCredential:self.username.text toPassword:self.password.text];
            [self.postService apiCallToPost:[self.settings getLogInUrl] serializedData:[self.dataSerialization toJson] callback:^(NSDictionary *response){
                if ([[response objectForKey:@"response"] isEqualToString:@"success"]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"auth_token"] forKey:@"token"];
                        [self performSegueWithIdentifier:@"LoggedIn" sender:self];
                    });
                }else{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [ShowAlert alertWithMessage:@"Warning!" message:@"Invalid username or password."];
                    });
                }
            }];
        }else{
            [ShowAlert alertWithMessage:@"Warning!" message:@"You tried with an invalid user email."];
        }
    }else{
        [ShowAlert alertWithMessage:@"Warning!" message:@"Username or password should not be empty."];
    }
}

- (IBAction)forgotPassBtnEventListener:(id)sender {
    [self performSegueWithIdentifier:@"ForgotPassword" sender:nil];
}

- (IBAction)registrationBtnEventListener:(id)sender {
    [self performSegueWithIdentifier:@"Registration" sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.username.layer.borderWidth = 1;
    self.username.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.password.layer.borderWidth = 1;
    self.password.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    
    self.settings = [[Settings alloc]init];
    self.postService = [[PostService alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }*/


@end
