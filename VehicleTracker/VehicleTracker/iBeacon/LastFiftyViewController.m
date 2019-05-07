
//  LastFiftyViewController.m
//  MCP
//
//  Created by Rafay Hasan on 6/2/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "LastFiftyViewController.h"
#import "BeaconItem.h"
#import "AppDelegate.h"
@interface LastFiftyViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation LastFiftyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //NSLog(@" status is %@",self.statusName);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table view delegate Method starts

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.beaconStatusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
//    BeaconItem *item = self.items[indexPath.row];
//    cell.item = item;
//    cell.detailTextLabel.text = self.titlee;
    
    cell.textLabel.text = [appDelegate.beaconStatusArray objectAtIndex:indexPath.row];
    
    return cell;
    
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
