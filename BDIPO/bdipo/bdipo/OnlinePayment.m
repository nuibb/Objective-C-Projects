//
//  OnlinePayment.m
//  bdipo
//
//  Created by Nascenia on 4/17/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "OnlinePayment.h"
#import "WebViewShow.h"
#import "Settings.h"
#import "GetServices.h"
#import "PostService.h"
#import "ShowAlert.h"
#import "JsonConversion.h"
#import "JsonForDBBLGateway.h"

@interface OnlinePayment ()
@property Settings *settings;
@property GetServices *getService;
@property PostService *postService;
@property NSArray *dbblCardArray;
@property NSArray *otherCardArray;
@property NSString *dbblGatewayUrl;
@property NSString *transectionId;
@end

@implementation OnlinePayment

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.settings = [[Settings alloc]init];
    self.getService = [[GetServices alloc]init];
    self.postService = [[PostService alloc]init];
    self.dbblCardArray = [[NSArray alloc] initWithObjects:@"DBBL Nexus", @"DBBL Master", @"Visa Debit", nil];
    self.otherCardArray = [[NSArray alloc] initWithObjects:@"Visa", @"Master", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section ? [self.otherCardArray count] : [self.dbblCardArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section) {
        cell.textLabel.text = self.otherCardArray[indexPath.row];
    }else{
        cell.textLabel.text = self.dbblCardArray[indexPath.row];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section) {
        return @"Other Cards";
    }else{
        return @"DBBL Cards";
    }
}

-(void)apiCallForDBBLPaymentGateway:(NSString *) provider {
    NSData *data = [JsonConversion toJson:[[[JsonForDBBLGateway alloc] initWithDBBLCredential:_paymentId toProvider:provider] getDictionary]];
    [self.postService apiCallToPost:[self.settings getDBBLpaymentGateway] serializedData:data callback:^(NSDictionary *response){
        if ([response[@"status"] isEqualToString:@"success"]){
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.dbblGatewayUrl = response[@"dbbl_payment_gateway_link"];
                self.transectionId = response[@"dbbl_transaction_id"];
                [self performSegueWithIdentifier:@"DBBLForm" sender:self];
            });
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger num;
    if (indexPath.section) {
        if (indexPath.row) {
            num = 5;
        }else{
            num = 4;
        }
    }else{
        num = indexPath.row + 1;
    }
    [self apiCallForDBBLPaymentGateway:[@(num) stringValue]];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DBBLForm"]) {
        WebViewShow *vc = (WebViewShow *)[segue destinationViewController];
        vc.url = self.dbblGatewayUrl;
    }
}

- (IBAction)unwindToOnlinePayment:(UIStoryboardSegue *)unwindSegue {
    //WebViewShow *vc = (WebViewShow *)[unwindSegue sourceViewController];
    if (self.isMovingFromParentViewController) {
        [self.getService apiCallToGet:[self.settings checkDBBLPayment:self.transectionId] callback:^(NSDictionary *response){
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([response[@"status"] isEqualToString:@"failed"]) {
                    [ShowAlert alertWithMessage:@"Message!" message:response[@"message"]];
                }else{
                    [self performSegueWithIdentifier:@"RegisteredForOnline" sender:self];
                }
            });
        }];
    }
}

@end
