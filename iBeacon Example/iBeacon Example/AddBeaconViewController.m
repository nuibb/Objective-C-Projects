//
//  AddBeaconViewController.m
//  iBeacon Example
//
//  Created by Rafay Hasan on 5/26/15.
//  Copyright (c) 2015 Rafay Hasan. All rights reserved.
//

#import "AddBeaconViewController.h"
#import "BeaconItem.h"
@interface AddBeaconViewController ()

@property (weak, nonatomic) IBOutlet UITextField *beaconUUIDtextfield;


@property (weak, nonatomic) IBOutlet UITextField *beaconMajorIdTextField;


@property (weak, nonatomic) IBOutlet UITextField *beaconMinorIdTextField;


@property (weak, nonatomic) IBOutlet UITextField *beaconNameTextField;

- (IBAction)saveButtonAction:(id)sender;

@property (strong, nonatomic) NSRegularExpression *uuidRegex;
@property (assign, nonatomic, getter = isNameFieldValid) BOOL nameFieldValid;
@property (assign, nonatomic, getter = isUUIDFieldValid) BOOL UUIDFieldValid;
@property (assign, nonatomic, getter = isMajorIDFieldValid) BOOL MajorIdFieldValid;
@property (assign, nonatomic, getter = isMinorIDFieldValid) BOOL MinorIDFieldValid;



@end

@implementation AddBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.beaconNameTextField addTarget:self action:@selector(nameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.beaconUUIDtextfield addTarget:self action:@selector(uuidTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    self.uuidRegex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];

}

- (void)nameTextFieldChanged:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.nameFieldValid = YES;
    } else {
        self.nameFieldValid = NO;
    }
    
    //self.saveBarButtonItem.enabled = self.isNameFieldValid && self.isUUIDFieldValid;
}

- (void)uuidTextFieldChanged:(UITextField *)textField {
    NSInteger numberOfMatches = [self.uuidRegex numberOfMatchesInString:textField.text
                                                                options:kNilOptions
                                                                  range:NSMakeRange(0, textField.text.length)];
    if (numberOfMatches > 0) {
        self.UUIDFieldValid = YES;
    } else {
        self.UUIDFieldValid = NO;
    }
    
    //self.saveBarButtonItem.enabled = self.isNameFieldValid && self.isUUIDFieldValid;
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

- (IBAction)saveButtonAction:(id)sender {
    
    
    [self.view endEditing:YES];
    
    //if(self.nameFieldValid && self.UUIDFieldValid )
    {
        if (self.itemAddedCompletion) {
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.beaconUUIDtextfield.text];
            BeaconItem *newItem = [[BeaconItem alloc] initWithName:self.beaconNameTextField.text
                                                              uuid:uuid
                                                             major:[self.beaconMajorIdTextField.text intValue]
                                                             minor:[self.beaconMinorIdTextField.text intValue]];
            self.itemAddedCompletion(newItem);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }/*
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter data in proper format" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
    }*/
    
}
@end
