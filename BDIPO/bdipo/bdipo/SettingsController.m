//
//  SettingsController.m
//  bdipo
//
//  Created by Nascenia on 4/24/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "SettingsController.h"
#import "EditProfile.h"
#import "LogOutController.h"
#import "CustomCellForSettings.h"
#import "ShowAlert.h"
#import "GetServices.h"
#import "Settings.h"

@interface SettingsController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property GetServices *getService;
@property Settings *settings;
@property NSDictionary *profileObject;
@property NSMutableArray *profileObjectArray;
@end

@implementation SettingsController

- (IBAction)logOutEventListener:(id)sender {
    LogOutController *controller = [[LogOutController alloc] init];
    [self presentViewController:[controller getActionSheet] animated:YES completion:nil];
}

-(void)makeApiCall{
    [self.getService apiCallToGet:[self.settings getUserAccount] callback:^(NSDictionary *response){
        if (response[@"user"]) {
            self.profileObject = response[@"user"];
            
            // Update the UI on the main thread.
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Initialize objects for API call
    self.settings = [[Settings alloc]init];
    self.getService = [[GetServices alloc]init];
    self.profileObjectArray = [[NSMutableArray alloc] init];
    
    //Make API call to get profile data
    [self makeApiCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(NSString *)getCellTitleForEachRow:(NSInteger)row {
    switch (row) {
        case 0:
            return @"Login ID";
        case 1:
            return @"Your Account";
        case 2:
            return @"Expires On";
        case 3:
            return @"Edit Profile";
        case 4:
            return @"Send Feedback";
        case 5:
            return @"Call Us";
        default:
            return @"";
    }
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellForSettings *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.rowTitle.text = [self getCellTitleForEachRow:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.rowValue.text = [self getDataFromProfileObject:@"login"];
    }else if(indexPath.row == 1) {
        cell.rowValue.text = [self getDataFromProfileObject:@"pricing_plan_name"];
    }else if(indexPath.row == 2){
        cell.rowValue.text = [self getDataFromProfileObject:@"expires_on"];
    }else if (indexPath.row == 3 || indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.rowTitle.textColor = [UIColor colorWithRed: 0.0f/255.0f green:120.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.rowValue.textColor = [UIColor colorWithRed: 0.0f/255.0f green:120.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    }else if(indexPath.row == 5) {
        cell.rowValue.text = @"01730 332503";
    }
    
    return cell;
}

- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObject:@"support@bdipo.com"];
    [picker setToRecipients:toRecipients];
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"EditProfile" sender:self];
    }else if (indexPath.row == 4) {
        // The device can send email.
        if ([MFMailComposeViewController canSendMail]){
            [self displayMailComposerSheet];
        }else{
            [ShowAlert alertWithMessage:@"Warnings" message:@"Your device not configured to send mail."];
        }
    }
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    // Notifies users about errors associated with the interface
    switch (result){
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            [ShowAlert alertWithMessage:@"Message!" message:@"Mail has been saved"];
            break;
        case MFMailComposeResultSent:
            [ShowAlert alertWithMessage:@"Message!" message:@"Mail has been sent"];
            break;
        case MFMailComposeResultFailed:
            [ShowAlert alertWithMessage:@"Warnings" message:@"Mail sending failed"];
            break;
        default:
            [ShowAlert alertWithMessage:@"Warnings" message:@"Mail can not be sent"];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
