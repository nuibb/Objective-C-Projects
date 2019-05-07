//
//  FirstViewController.m
//  bdipo
//
//  Created by Nascenia on 2/24/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "FirstViewController.h"
#import "GetServices.h"
#import "Settings.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property GetServices *getService;
@property Settings *settings;
@property NSMutableArray *ipoResultsList;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Get ipo results from server and reload the table view
    self.ipoResultsList = [[NSMutableArray alloc] init];
    self.settings = [[Settings alloc]init];
    self.getService = [[GetServices alloc]init];
    [self.getService apiCallToGet:[self.settings getIPOResultsList] callback:^(NSDictionary *response){
        for (NSDictionary *result in response) {
            if ([result objectForKey:@"company_id"] && [result objectForKey:@"name"]) {
                [self.ipoResultsList addObject:result];
            }
        }
        
        // Update the UI on the main thread.
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.ipoResultsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *result = self.ipoResultsList[indexPath.row];
    cell.textLabel.text = [result objectForKey:@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"searchForResult" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SearchIPOResult *vc = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    vc.cName = cell.textLabel.text;
    NSDictionary *result = self.ipoResultsList[indexPath.row];
    vc.companyId = [result objectForKey:@"company_id"];
}

@end
