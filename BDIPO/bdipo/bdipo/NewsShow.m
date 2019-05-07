//
//  NewsShow.m
//  bdipo
//
//  Created by Nascenia on 3/9/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "NewsShow.h"
#import "ShowAlert.h"

@interface NewsShow ()
@property BOOL theBool;
@property NSTimer *myTimer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewsShow

-(void)showProgressView {
    self.progressView.progress = 0;
    self.theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

-(void)hideProgressView {
    self.theBool = true;
}

-(void)timerCallback {
    if (self.theBool) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.myTimer invalidate];
        }
        else {
            self.progressView.progress += 0.1;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.95) {
            self.progressView.progress = 0.95;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyName.text = self.cName;
    NSURL *URL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self showProgressView];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideProgressView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideProgressView];
    [ShowAlert alertWithMessage:@"Warning!" message:@"Sorry, could not load the web page. Something went wrong."];
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

@end
