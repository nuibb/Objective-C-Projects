//
//  LoginViewController.m
//  Meeting Mate
//
//  Created by nuibb on 8/4/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPSessionManager.h"
#import "ShowAlert.h"
#import "Settings.h"
#import "PostService.h"
#import "JsonForLogin.h"

@interface LoginViewController ()

@property (strong, nonatomic) NSDictionary* json;
@property (strong, nonatomic) NSDictionary *status;
@property Settings *settings;
@property PostService *postService;
@property JsonForLogin *dataSerialization;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)logInBtnEventListener:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

-(void) getDataAfterLogin {
    NSDictionary *params = @{@"username": self.username.text, @"password":self.password.text};
    self.json=[[NSDictionary alloc] init];
    self.status=[[NSDictionary alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[self.settings getLogInUrl] parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        self.status = [json objectForKey:@"login_info"];
        
        if([[self.status objectForKey:@"status"] isEqualToString:@"yes"]) {
            [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"login_credentials"];
            [self performSegueWithIdentifier:@"showSplitView" sender:self];
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
        } else {
            [ShowAlert alertWithMessage:@"Warning!" message:@"Username or password is not valid."];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;


    }];
    
    /*self.operationManager = [AFHTTPRequestOperationManager manager];
    self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];*/
    
    
    /*[self.operationManager POST:[self.settings getLogInUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
        
        self.status=[self.json objectForKey:@"login_info"];
        
        if([[self.status objectForKey:@"status"] isEqualToString:@"yes"]) {
            [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"login_credentials"];
            [self performSegueWithIdentifier:@"showSplitView" sender:self];
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
        } else {
            [ShowAlert alertWithMessage:@"Warning!" message:@"Username or password is not valid."];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        NSLog(@"error  is  %@", error);
    }];*/
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden=YES;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityIndicator setColor:[UIColor purpleColor]];
    
    self.settings = [[Settings alloc]init];
    self.postService = [[PostService alloc]init];
    
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

- (IBAction)logInBtnEventListener:(id)sender {
    
    //Get authentication token by login
    /*if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
     self.dataSerialization = [[JsonForLogin alloc] initWithLoginCredential:self.username.text toPassword:self.password.text];
     NSLog(@"%@", [[NSString alloc] initWithData:[self.dataSerialization toJson] encoding:NSUTF8StringEncoding]);
     [self.postService apiCallToPost:[self.settings getLogInUrl] serializedData:[self.dataSerialization toJson] callback:^(NSDictionary *response){
     
     NSLog(@"%@", response);
     
     }];
     }else{
     [ShowAlert alertWithMessage:@"Warning!" message:@"Username or password should not be empty."];
     }*/
    
    
    
    ////////////////////////////////////////////
    /*if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_credentials"]){
     NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"login_credentials"]);
     }else{
     NSLog(@"no value");
     }*/
    
    
    if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = NO;
        [self getDataAfterLogin];
    } else {
        [ShowAlert alertWithMessage:@"Warning!" message:@"Username or password should not be empty."];
    }
}
@end
