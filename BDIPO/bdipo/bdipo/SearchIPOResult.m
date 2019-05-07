//
//  SearchIPOResult.m
//  bdipo
//
//  Created by Nascenia on 3/9/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "SearchIPOResult.h"
#import "ShowAlert.h"
#import "GetServices.h"
#import "PostService.h"
#import "Settings.h"
#import "JsonForBankSearch.h"
#import "JsonForBranchSearch.h"
#import "JsonConversion.h"

@interface SearchIPOResult ()

@property GetServices *getService;
@property PostService *postService;
@property Settings *settings;
@property JsonForBankSearch *bankSerializedData;
@property JsonForBranchSearch *branchSerializedData;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UITextField *bank;
@property (weak, nonatomic) IBOutlet UITextField *branch;
@property (weak, nonatomic) IBOutlet UITextField *serialNumber1;
@property (weak, nonatomic) IBOutlet UITextField *serialNumber2;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property UIPickerView *bankPicker;
@property UIPickerView *branchPicker;
@property NSMutableArray *bankArray;
@property NSMutableArray *branchArray;
@property NSMutableDictionary *searchDictionary;
@property NSMutableArray *searchResult;
@property UITextField *activeField;

@end

@implementation SearchIPOResult

-(void) getDataAfterSearch:(NSData *)data{
    [self.postService apiCallToPost:[self.settings getSearchIPOResult] serializedData:data callback:^(NSDictionary *response){
        [self.searchResult removeAllObjects];
        if ([response count]) {
            for (NSDictionary *result in response) {
                [self.searchResult addObject:result];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"showIPOResult" sender:nil];
            });
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [ShowAlert alertWithMessage:@"Message!" message:@"No IPO is issued for this result search."];
            });
        }
    }];
}

- (IBAction)searchEventListener:(id)sender {
    if (![self.bank.text isEqualToString:@""] && ![self.branch.text isEqualToString:@""] && ![self.serialNumber1.text isEqualToString:@""] && ![self.serialNumber2.text isEqualToString:@""]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *serialNo1 = [formatter numberFromString:self.serialNumber1.text];
        NSNumber *serialNo2 = [formatter numberFromString:self.serialNumber2.text];
        
        if (serialNo1 && serialNo2) {
            if (serialNo1.intValue < serialNo2.intValue) {
                [self.searchDictionary setValue: _companyId forKey:@"company_id"];
                [self.searchDictionary setValue: @"2" forKey:@"result_category_id"];
                [self.searchDictionary setValue: self.serialNumber1.text forKey:@"from_no"];
                [self.searchDictionary setValue: self.serialNumber2.text forKey:@"to_no"];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
                    [self.searchDictionary setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"auth_token"];
                }
                
                [self getDataAfterSearch:[JsonConversion toJson:self.searchDictionary]];
            }else{
                [ShowAlert alertWithMessage:@"Message!" message:@"First serial number must be less than the second"];
            }
        }else{
            [ShowAlert alertWithMessage:@"Message!" message:@"Serial number only allow integer"];
        }
    }else{
        [ShowAlert alertWithMessage:@"Message!" message:@"All the fields must be fill up"];
    }
}

-(void)makeBorderColorForTextFields{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.bank.layer.borderWidth = 1;
    self.bank.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.branch.layer.borderWidth = 1;
    self.branch.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.serialNumber1.layer.borderWidth = 1;
    self.serialNumber1.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    self.serialNumber2.layer.borderWidth = 1;
    self.serialNumber2.layer.borderColor=[[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
}

-(void)initializePickerViewForTextFieldsInput{
    self.bankPicker = [[UIPickerView alloc] init];
    self.bankPicker.dataSource = self;
    self.bankPicker.delegate = self;
    self.bank.inputView = self.bankPicker;
    
    self.branchPicker = [[UIPickerView alloc] init];
    self.branchPicker.dataSource = self;
    self.branchPicker.delegate = self;
    self.branch.inputView = self.branchPicker;
}

- (void)makeApiCall {
    [self.getService apiCallToGet:[self.settings checkAuthorization:self.companyId] callback:^(NSDictionary *response){
        if ([response[@"status"] isEqualToString:@"error"]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [ShowAlert alertWithMessage:@"Message!" message:response[@"message"]];
            });
        }
    }];
    
    self.bankSerializedData = [[JsonForBankSearch alloc] initWithBankCredential:self.companyId];
    [self.postService apiCallToPost:[self.settings getBankListForSearch] serializedData:[self.bankSerializedData toJson] callback:^(NSDictionary *response){
        //NSLog(@"%@", response);
        for (NSDictionary *banks in response) {
            NSString *bank_code = [banks objectForKey:@"bank_code"];
            NSArray *bank_list = [banks objectForKey:@"bank_name"];
            for (NSDictionary *bank in bank_list) {
                [self.bankArray addObject:[NSString stringWithFormat:@"%@ [%@]", bank, bank_code]];
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self makeBorderColorForTextFields];
    self.companyName.text = _cName;
    
    //Pop up picker view instead of keyboard for first three text field
    [self initializePickerViewForTextFieldsInput];
    
    
    //Initialize objects for API call
    self.settings = [[Settings alloc]init];
    self.getService = [[GetServices alloc] init];
    self.postService = [[PostService alloc]init];
    self.searchDictionary = [[NSMutableDictionary alloc]init];
    self.searchResult = [[NSMutableArray alloc]init];
    self.bankArray = [[NSMutableArray alloc]init];
    self.branchArray = [[NSMutableArray alloc]init];
    
    //Make API Call to get data from server
    [self makeApiCall];
    
    //Moving Content That Is Located Under the Keyboard
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.bankPicker){
        return [self.bankArray count];
    }else if(pickerView == self.branchPicker){
        return [self.branchArray count];
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView == self.bankPicker){
        NSString *result = self.bankArray[row];
        return result;
    }else if(pickerView == self.branchPicker){
        NSDictionary *result = self.branchArray[row];
        return [result objectForKey:@"name"];
    }
    return nil;
}

- (void)getBankCode:(NSInteger)row {
    NSString *result = self.bankArray[row];
    NSArray *splitArray = [result componentsSeparatedByCharactersInSet:
                           [NSCharacterSet characterSetWithCharactersInString:@"[]"]
                           ];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *bankCode = [formatter numberFromString:splitArray[1]];
    if (bankCode) {
        [self.searchDictionary setValue:splitArray[1] forKey:@"bank_code"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView == self.bankPicker){
        if ([self.bankArray count]) {
            [self getBankCode:row];
        }
    }else if(pickerView == self.branchPicker){
        if ([self.branchArray count]) {
            NSDictionary *result = self.branchArray[row];
            [self.searchDictionary setValue:[[result objectForKey:@"code"] stringValue] forKey:@"branch_code"];
        }
    }
    [self.bank resignFirstResponder];
    [self.branch resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.activeField = textField;
    if(textField == self.bank){
        [self.bankPicker reloadAllComponents];
    }else if(textField == self.branch){
        if (![self.bank.text isEqualToString:@""]) {
            NSArray *splitArray = [self.bank.text componentsSeparatedByCharactersInSet:
                                   [NSCharacterSet characterSetWithCharactersInString:@"[]"]
                                   ];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *bankCode = [formatter numberFromString:splitArray[1]];
            
            if (bankCode) {
                self.branchSerializedData = [[JsonForBranchSearch alloc] initWithBranchCredential:_companyId code:splitArray[1]];
                [self.postService apiCallToPost:[self.settings getBranchListForSearch] serializedData:[self.branchSerializedData toJson] callback:^(NSDictionary *response){
                    [self.branchArray removeAllObjects];
                    
                    for (NSDictionary *branch in response) {
                        [self.branchArray addObject:branch];
                    }
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.branchPicker reloadAllComponents];
                    });
                }];
            }
        }else{
            [ShowAlert alertWithMessage:@"Message!" message:@"Select a bank at first"];
        }
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.activeField = nil;
    if(textField == self.bank && [self.bankPicker selectedRowInComponent:0] < [self.bankArray count]){
        textField.text = [self.bankArray objectAtIndex:[self.bankPicker selectedRowInComponent:0]];
    }else if(textField == self.branch && [self.branchPicker selectedRowInComponent:0] < [self.branchArray count]){
        textField.text = [[self.branchArray objectAtIndex:[self.branchPicker selectedRowInComponent:0]] objectForKey:@"name"];
        
    }
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

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 [self.serialNumber1 resignFirstResponder];
 [self.serialNumber2 resignFirstResponder];
 }*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowIPOResult *vc = [segue destinationViewController];
    vc.cName = _cName;
    vc.descText = [NSString stringWithFormat:@"%ld%@%@%@%@", (unsigned long)[self.searchResult count], @" IPOs are issued against the serials of ", self.serialNumber1.text, @" to ", self.serialNumber2.text];
    vc.searchResult = self.searchResult;
}

@end
