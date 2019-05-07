//
//  RegisterWithPayment.m
//  bdipo
//
//  Created by Nascenia on 4/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RegisterWithPayment.h"
#import "SignUpCredentials.h"
#import "SignUpCredentialsForTrialUser.h"
#import "JsonConversion.h"
#import "ShowAlert.h"
#import "PostService.h"
#import "GetServices.h"
#import "Settings.h"
#import "OtherPayment.h"
#import "OnlinePayment.h"

@interface RegisterWithPayment ()
@property GetServices *getService;
@property PostService *postService;
@property Settings *settings;
@property UIPickerView *picker;
@property NSArray *pickerArray;
@property NSString *paymentCost;
@property NSString *invoiceId;
@property NSString *paymentId;
@end

@implementation RegisterWithPayment

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)signUpEventListener:(id)sender {
    if (![self.email.text isEqualToString:@""] && ![self.fullname.text isEqualToString:@""] && ![self.password.text isEqualToString:@""] && ![self.retypePassword.text isEqualToString:@""]) {
        if ([self isValidEmail:self.email.text]) {
            if ([self.password.text length]>= 4) {
                if ([self.password.text isEqualToString:self.retypePassword.text]) {
                    if (!self.isTrialAccount) {
                        if (![self.choosePlan.text isEqualToString:@""]) {
                            NSData *jsonData = [JsonConversion toJson:[[[SignUpCredentials alloc] initWithSignUpCredentials:self.planType toMail:self.email.text toName:self.fullname.text toPassword:self.password.text toConfirm:self.retypePassword.text toPayment:[self.choosePlan.text lowercaseString]] getDictionary]];
                            
                            [self.postService apiCallToPost:[self.settings getSignUpUrl] serializedData:jsonData callback:^(NSDictionary *response){
                                if ([response[@"status"] isEqualToString:@"error"]) {
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        [ShowAlert alertWithMessage:@"Message!" message:@"This email already has been used."];
                                    });
                                }else{
                                    if (response[@"invoice"]) {
                                        [[NSUserDefaults standardUserDefaults] setObject:[response[@"invoice"] objectForKey:@"auth_token"] forKey:@"token"];
                                        self.paymentCost = [response[@"invoice"] objectForKey:@"invoice_amount"];
                                        self.invoiceId = [response[@"invoice"] objectForKey:@"invoice_id"];
                                        
                                        //New payment api call with new invoice credentials
                                        [self.getService apiCallToGet:[self.settings getPaymentUrlWithInvoice:[response[@"invoice"] objectForKey:@"invoice_id"] methodName:[self.choosePlan.text lowercaseString]] callback:^(NSDictionary *response){
                                            dispatch_sync(dispatch_get_main_queue(), ^{
                                                if ([self.choosePlan.text isEqualToString:@"Online"]) {
                                                    self.paymentId = response[@"payment_id"];
                                                    [self performSegueWithIdentifier:@"OnlinePayment" sender:self];
                                                }else{
                                                    [self performSegueWithIdentifier:@"OtherPayment" sender:self];
                                                }
                                            });
                                        }];
                                    }
                                }
                            }];
                        }else{
                            [ShowAlert alertWithMessage:@"Message!" message:@"All the fields must be fill up"];
                        }
                    }else{
                        //For trial account
                        NSData *jsonData = [JsonConversion toJson:[[[SignUpCredentialsForTrialUser alloc] initWithSignUpCredentialsForTrialUser:self.planType toMail:self.email.text toName:self.fullname.text toPassword:self.password.text toConfirm:self.retypePassword.text] getDictionary]];
                        [self.postService apiCallToPost:[self.settings getSignUpUrlForTrialUser] serializedData:jsonData callback:^(NSDictionary *response){
                            if (response[@"user"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:[response[@"user"] objectForKey:@"auth_token"] forKey:@"token"];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [self performSegueWithIdentifier:@"RegisteredForTrial" sender:self];
                                });
                            }
                        }];
                    }
                }else{
                    [ShowAlert alertWithMessage:@"Message!" message:@"Your password does not matching."];
                }
            }else{
                [ShowAlert alertWithMessage:@"Message!" message:@"Password should be atleast 4 characters."];
            }
        }else{
            [ShowAlert alertWithMessage:@"Message!" message:@"Invalid user email."];
        }
    }else{
        [ShowAlert alertWithMessage:@"Message!" message:@"All the fields must be fill up"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.email.layer.borderWidth = 1;
    self.email.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.fullname.layer.borderWidth = 1;
    self.fullname.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.password.layer.borderWidth = 1;
    self.password.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.retypePassword.layer.borderWidth = 1;
    self.retypePassword.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.choosePlan.layer.borderWidth = 1;
    self.choosePlan.layer.borderColor=[[UIColor colorWithRed: 83.0f/255.0f green:80.0f/255.0f blue:168.0f/255.0f alpha:1.0] CGColor];
    
    self.pickerArray = [[NSArray alloc] initWithObjects:@"Online", @"bKash", @"Manual", nil];
    self.picker = [[UIPickerView alloc] init];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.choosePlan.inputView = self.picker;
    
    if (self.isTrialAccount) {
        self.choosePlan.hidden = YES;
        self.staticText.hidden = YES;
    }
    
    self.settings = [[Settings alloc]init];
    self.postService = [[PostService alloc]init];
    self.getService = [[GetServices alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.paymentText.text = @"Use DBBL Nexus, Visa or MasterCard through secured payment gateway of Dutch-Bangla Bank";
    }else if(row == 1){
        self.paymentText.text = @"Send money using bKash and notify us";
    }else if(row == 2){
        self.paymentText.text = @"Deposit in our bank account manually and notify us";
    }
    
    [self.choosePlan resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.choosePlan) {
        self.choosePlan.text = [self.pickerArray objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OtherPayment"]) {
        OtherPayment *vc = (OtherPayment *)[segue destinationViewController];
        vc.paymentType = self.choosePlan.text;
        vc.paymentCost = self.paymentCost;
        vc.invoiceId = self.invoiceId;
    }else if([segue.identifier isEqualToString:@"OnlinePayment"]){
        OnlinePayment *vc = (OnlinePayment *)[segue destinationViewController];
        vc.paymentId = self.paymentId;
    }
}

@end
