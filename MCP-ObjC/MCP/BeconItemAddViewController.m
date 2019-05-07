//
//  BeconItemAddViewController.m
//  MCP
//
//  Created by Rafay Hasan on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "BeconItemAddViewController.h"
#import "BeaconItem.h"
@interface BeconItemAddViewController ()


- (IBAction)saveButtonAction:(id)sender;


- (IBAction)cancelButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *beaconNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *beaconUUIDTextField;

@property (weak, nonatomic) IBOutlet UITextField *beaconMajorIdTextField;


@property (weak, nonatomic) IBOutlet UITextField *beaconMinorIdTextField;



- (IBAction)addDefaultBeaconAction:(id)sender;


- (IBAction)addMcpBeaconButtonAction:(id)sender;

@end

@implementation BeconItemAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    NSLog(@"here comes");
    
    
    
    if(self.beaconNameTextField.text.length > 0 && self.beaconUUIDTextField.text.length > 0)
    {
        if (self.itemAddedCompletion) {
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.beaconUUIDTextField.text];
            BeaconItem *newItem = [[BeaconItem alloc] initWithName:self.beaconNameTextField.text
                                                              uuid:uuid
                                                             major:[self.beaconMajorIdTextField.text intValue]
                                                             minor:[self.beaconMinorIdTextField.text intValue]];
            self.itemAddedCompletion(newItem);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter Beacon UUID and name correctly" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
    
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addDefaultBeaconAction:(id)sender {
    
    self.beaconNameTextField.text = @"Nascenia Beacon";
    
    self.beaconUUIDTextField.text = @"20CAE8A0-A9CF-11E3-A5E2-0800200C9A66";
    
    self.beaconMajorIdTextField.text = @"213";
    
    self.beaconMinorIdTextField.text = @"2386";
    
}

- (IBAction)addMcpBeaconButtonAction:(id)sender {
    
    self.beaconNameTextField.text = @"MCP Beacon";
    
    self.beaconUUIDTextField.text = @"20CAE8A0-A9CF-11E3-A5E2-0800200C9A66";
    
    self.beaconMajorIdTextField.text = @"213";
    
    self.beaconMinorIdTextField.text = @"1355";

    
}
@end
