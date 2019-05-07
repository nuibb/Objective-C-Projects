//
//  OtherPayment.m
//  bdipo
//
//  Created by Nascenia on 4/17/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "OtherPayment.h"
#import "ShowAlert.h"
#import "Settings.h"
#import "PostService.h"
#import "WebViewShow.h"
#import "JsonConversion.h"
#import "JsonForbKashPayment.h"
#import "JsonForManualPayment.h"

@interface OtherPayment ()
@property Settings *settings;
@property PostService *postService;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextField *IDField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *paymentMode;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property UIDatePicker *datePicker;
@property UIPickerView *paymentModePicker;
@property NSArray *paymentModePickerArray;
@end

@implementation OtherPayment

- (IBAction)paidBtnEventListener:(id)sender {
    self.IDField.hidden = NO;
    self.dateField.hidden = NO;
    self.submitBtn.hidden = NO;
    if(![self.paymentType isEqualToString:@"bKash"]){
        self.paymentMode.hidden = NO;
    }
}

- (IBAction)helpBtnEventListener:(id)sender {
    [self performSegueWithIdentifier:@"Forum" sender:self];
}

-(void)showAlertController{
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message!" message:@"Thank you for letting us know about your payment. Enjoy the services of trial account until your account gets updated. Please let us know if your account does not get updated within 48 hours from informing us.\nEmail: support@bdipo.com\nHotline: 01730 332503." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        [alert show];
    });
}

- (IBAction)submitBtnEventListener:(id)sender {
    if ([self.paymentType isEqualToString:@"bKash"]) {
        if (![self.IDField.text isEqualToString:@""] && ![self.IDField.text isEqualToString:@""]) {
            NSData *data = [JsonConversion toJson:[[[JsonForbKashPayment alloc] initWithbKashCredential:self.invoiceId trId:self.IDField.text date:self.IDField.text] getDictionary]];
            [self.postService apiCallToPost:[self.settings getbKashPaymentUrl] serializedData:data callback:^(NSDictionary *response){
                if ([response[@"status"] isEqualToString:@"success"]){
                    [self showAlertController];
                }
            }];
        }else{
            [ShowAlert alertWithMessage:@"Message!" message:@"You must provide payment ID & payment date to submit."];
        }
    }else{
        if (![self.IDField.text isEqualToString:@""] && ![self.dateField.text isEqualToString:@""] && ![self.paymentMode.text isEqualToString:@""]) {
            NSData *data = [JsonConversion toJson:[[[JsonForManualPayment alloc] initWithManualCredential:_invoiceId branch:self.IDField.text mode:self.paymentMode.text date:self.dateField.text] getDictionary]];
            [self.postService apiCallToPost:[self.settings getManualPaymentUrl] serializedData:data callback:^(NSDictionary *response){
                if ([response[@"status"] isEqualToString:@"success"]){
                    [self showAlertController];
                }
            }];
        }else{
            [ShowAlert alertWithMessage:@"Message!" message:@"You must provide payment ID, payment date & payment mode to submit."];
        }
    }
}

-(NSString *)getPaymentString{
    if ([self.paymentType isEqualToString:@"bKash"]) {
        return @"excluding bKash service charge. This is an Agent account.";
    }else{
        return [NSString stringWithFormat:@"%@%@%@", @"A/C Name: Nascenia Limited\nA/C Number: 108.110.19642 \nBank Name: Dutch-Bangla Bank Limited\n\nYou must write ", self.paymentCost, @" on your deposit slip."];
    }
}

-(void)selectedDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//@"dd-MM-yyyy HH:mm"
    NSString *strDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.dateField.text = strDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.settings = [[Settings alloc]init];
    self.postService = [[PostService alloc]init];
    
    self.IDField.hidden = YES;
    self.IDField.placeholder = [self.paymentType isEqualToString:@"bKash"] ? @"bKash Tnansection ID" : @"Branch Name";
    self.IDField.layer.borderWidth = 1;
    self.IDField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    
    self.dateField.hidden = YES;
    self.dateField.layer.borderWidth = 1;
    self.dateField.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    
    self.paymentMode.hidden = YES;
    self.paymentMode.layer.borderWidth = 1;
    self.paymentMode.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.submitBtn.hidden = YES;
    
    self.label.text = [self.paymentType isEqualToString:@"bKash"] ? [NSString stringWithFormat:@"%@%@%@", @"Pay Tk. ", self.paymentCost, @" to 01730 332503"] : [NSString stringWithFormat:@"%@%@%@", @"Pay Exactly Tk. ", self.paymentCost, @" to "];
    self.address.text = [self getPaymentString];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    [self.datePicker addTarget:self action:@selector(selectedDate) forControlEvents:UIControlEventValueChanged];
    self.dateField.inputView = self.datePicker;
    
    self.paymentModePicker = [[UIPickerView alloc] init];
    self.paymentModePicker.dataSource = self;
    self.paymentModePicker.delegate = self;
    self.paymentMode.inputView = self.paymentModePicker;
    self.paymentModePickerArray = [[NSArray alloc] initWithObjects:@"Cheque",@"Cash", nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self performSegueWithIdentifier:@"RegisteredForOther" sender:self];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.paymentModePicker){
        return [self.paymentModePickerArray count];
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView == self.paymentModePicker){
        return self.paymentModePickerArray[row];
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.paymentMode resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)doneBarButtonItemClicked{
    [self.dateField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.dateField) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonItemClicked)];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.paymentMode){
        textField.text = [self.paymentModePickerArray objectAtIndex:[self.paymentModePicker selectedRowInComponent:0]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Forum"]) {
        WebViewShow *vc = [segue destinationViewController];
        vc.url = [self.settings getForumUrl];
    }
}

@end
