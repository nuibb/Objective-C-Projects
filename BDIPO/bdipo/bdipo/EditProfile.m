//
//  EditProfile.m
//  bdipo
//
//  Created by Nascenia on 4/29/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "EditProfile.h"
#import "GetServices.h"
#import "PostService.h"
#import "Settings.h"
#import "JsonDataForUpdateProfile.h"
#import "JsonConversion.h"
#import "ShowAlert.h"

@interface EditProfile ()

@property NSDictionary *profileObject;
@property Settings *settings;
@property GetServices *getService;
@property PostService *postService;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *loginMail;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *secondaryMail;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassField;
@property (weak, nonatomic) IBOutlet UITextField *sexField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property UIPickerView *picker;
@property NSArray *pickerArray;
@property UITextField *activeField;

@end

@implementation EditProfile

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)apiCallToUpdateProfile{
    NSData *jsonData = [JsonConversion toJson:[[[JsonDataForUpdateProfile alloc] initWithProfileCredential:self.nameField.text secMail:self.secondaryMail.text toPassword:self.passwordField.text toConfirm:self.confirmPassField.text toSex:self.sexField.text toPhone:self.phoneField.text toLocation:self.locationField.text] getDictionary]];
    
    [self.postService apiCallToPost:[self.settings updateUserProfile] serializedData:jsonData callback:^(NSDictionary *response){
        if ([response[@"status"] isEqualToString:@"success"]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:response[@"auth_token"] forKey:@"token"];
                [ShowAlert alertWithMessage:@"Message!" message:@"Your account has been successfully updated."];
            });
        }
    }];
}

- (IBAction)updateBtnEventListener:(id)sender {
    if (![self.nameField.text isEqualToString:@""]) {
        if ([self.passwordField.text isEqualToString:self.confirmPassField.text]) {
            if ([self.secondaryMail.text isEqualToString:@""]) {
                [self apiCallToUpdateProfile];
            } else {
                if ([self isValidEmail:self.secondaryMail.text]) {
                    [self apiCallToUpdateProfile];
                } else {
                    [ShowAlert alertWithMessage:@"Warning!" message:@"You tried with an invalid user email."];
                }
            }
        } else {
            [ShowAlert alertWithMessage:@"Message!" message:@"Your password does not matching."];
        }
    } else {
        [ShowAlert alertWithMessage:@"Message!" message:@"User name should not be empty."];
    }
}

-(void)makeBorderColorForTextFields{
    self.nameField.layer.borderWidth = 1;
    self.nameField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.secondaryMail.layer.borderWidth = 1;
    self.secondaryMail.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.passwordField.layer.borderWidth = 1;
    self.passwordField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.confirmPassField.layer.borderWidth = 1;
    self.confirmPassField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.sexField.layer.borderWidth = 1;
    self.sexField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.phoneField.layer.borderWidth = 1;
    self.phoneField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.locationField.layer.borderWidth = 1;
    self.locationField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
}

-(NSString *) getDataFromProfileObject:(NSString *)key {
    if (self.profileObject) {
        if ([[self.profileObject allKeys] containsObject:key]) {
            id item =  [self.profileObject objectForKey:key];
            if (![item isEqual:[NSNull null]]) {
                return item;
            }
        }
    }
    
    return nil;
}

-(void)setTitleForTextFields{
    self.loginMail.text = [self getDataFromProfileObject:@"login"];
    self.nameField.text = [self getDataFromProfileObject:@"name"];
    self.secondaryMail.text = [self getDataFromProfileObject:@"secondary_email_address"];
    self.sexField.text = [self getDataFromProfileObject:@"sex"];
    self.phoneField.text = [self getDataFromProfileObject:@"phone_number"];
    self.locationField.text = [self getDataFromProfileObject:@"location"];
}

- (void)makeApiCall {
    [self.getService apiCallToGet:[self.settings getUserProfile] callback:^(NSDictionary *response){
        // Update the UI on the main thread.
        if (response[@"user"]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.profileObject = response[@"user"];
                [self setTitleForTextFields];
            });
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeBorderColorForTextFields];
    self.settings = [[Settings alloc] init];
    self.getService = [[GetServices alloc]init];
    self.postService = [[PostService alloc]init];
    self.pickerArray = [[NSArray alloc] initWithObjects:@"Male", @"Female", nil];
    self.picker = [[UIPickerView alloc] init];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.sexField.inputView = self.picker;
    
    //Load data from profile object after API call
    [self makeApiCall];
    
    //Moving Content That Is Located Under the Keyboard
    [self registerForKeyboardNotifications];
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
    [self.sexField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Managing Keyboard

// -------------------------------------------------------------------------------
//	keyboard notification
//  pop up text fields
// -------------------------------------------------------------------------------

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.sexField){
        textField.text = [self.pickerArray objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    self.activeField = nil;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 10.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

/*- (void)keyboardWasShown:(NSNotification*)aNotification {
 NSDictionary* info = [aNotification userInfo];
 CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 CGRect bkgndRect = self.activeField.superview.frame;
 bkgndRect.size.height += kbSize.height;
 [self.activeField.superview setFrame:bkgndRect];
 [self.scrollView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height) animated:YES];
 }*/

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
