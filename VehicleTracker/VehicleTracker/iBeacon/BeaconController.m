//
//  BeaconController.m
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "BeaconController.h"
#import "BeconItemAddViewController.h"
#import "BeaconItem.h"
#import "BeaconItemTableViewCell.h"
#import "LastFiftyViewController.h"
#import "AppDelegate.h"
@class corelocation;

NSString * const kRWTStoredItemsKey = @"storedItems";
@interface BeaconController () <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong,nonatomic) NSString *titlee;

@property (weak, nonatomic) IBOutlet UITableView *beaconListTableview;


@property (strong,nonatomic) NSMutableArray *lastFiftystatusArray;

@end

@implementation BeaconController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.beaconListTableview.rowHeight = 75;
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //[appDelegate.beaconStatusArray addObject:@"Unknown"];
    
    self.lastFiftystatusArray = [NSMutableArray new];
    
   // [self.lastFiftystatusArray addObject:@"123"];
    
    [self loadItems];

    
}




- (void)loadItems {
    
    NSArray *storedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kRWTStoredItemsKey];
    
    self.items = [NSMutableArray array];
    
    if (storedItems)
    {
        for (NSData *itemData in storedItems)
        {
            BeaconItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
            [self.items addObject:item];
            [self startMonitoringItem:item];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addBeaconItem"])
    {
        UINavigationController *navController = segue.destinationViewController;
        
        BeconItemAddViewController *addItemViewController = (BeconItemAddViewController *)navController.topViewController;
        
        [addItemViewController setItemAddedCompletion:^(BeaconItem *newItem) {
            
            
            [self.items addObject:newItem];
            [self.beaconListTableview beginUpdates];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.items.count-1 inSection:0];
            [self.beaconListTableview insertRowsAtIndexPaths:@[newIndexPath]
                                            withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.beaconListTableview endUpdates];
            [self startMonitoringItem:newItem];
            [self persistItems];
        }];
    }
    else if([segue.identifier isEqualToString:@"details"])
    {
        
//        NewsShow *vc = [segue destinationViewController];
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        vc.cName = cell.textLabel.text;
//        vc.url = [(News *)self.newsList[indexPath.row] url];
        
        
        //LastFiftyViewController *vc = (LastFiftyViewController *) [segue destinationViewController];
        
        
        //vc.statusName = @"123";
        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        vc.cName = cell.textLabel.text;
//        vc.url = [(News *)self.newsList[indexPath.row] url];
        
        
        
        //NewsShow *vc = [segue destinationViewController];
        //NSIndexPath *indexPath = [self.beaconListTableview indexPathForSelectedRow];
       // UITableViewCell *cell = [self.beaconListTableview cellForRowAtIndexPath:indexPath];
        
        //NSLog(@"here status array is %@",self.statusArray);
        
        //vc.status = @"this is a rtest ";
        
        //vc.statusArray = self.lastFiftystatusArray;
    }
}




- (void)persistItems {
    NSMutableArray *itemsDataArray = [NSMutableArray array];
    for (BeaconItem *item in self.items) {
        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
        [itemsDataArray addObject:itemData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:kRWTStoredItemsKey];
}

- (CLBeaconRegion *)beaconRegionWithItem:(BeaconItem *)item {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorValue
                                                                           minor:item.minorValue
                                                                      identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(BeaconItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    
    //beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    NSLog(@"Detected");
}

- (void)stopMonitoringItem:(BeaconItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    
    //NSLog(@"total items %lu",(unsigned long)self.items.count);
    
    for (CLBeacon *beacon in beacons) {
        for (BeaconItem *item in self.items) {
            if ([item isEqualToCLBeacon:beacon]) {
                item.lastSeenBeacon = beacon;
                //self.title = [self nameForProximity:item.lastSeenBeacon.proximity];
                
                NSLog(@"last seen proximity is %ld",(long)item.lastSeenBeacon.proximity);
                
                NSString *compareString = [NSString new];
                
                
                compareString = [appDelegate.beaconStatusArray lastObject];
                
                if([compareString isEqualToString:[self nameForProximity:item.lastSeenBeacon.proximity]])
                {
                    NSLog(@"same");
                }
                else
                {
                    if(appDelegate.beaconStatusArray.count <=50)
                    {
                        
                        NSString *obj = [NSString stringWithFormat:@"%@-%@",item.name,[self nameForProximity:item.lastSeenBeacon.proximity]];
                        
                        [appDelegate.beaconStatusArray addObject:obj];
                        
                        [self.beaconListTableview reloadData];
                    }
                }
                
                
                
                //NSLog(@"status ");
                
                //[self.beaconListTableview reloadData];
                //NSLog(@"status is %@",[self nameForProximity:item.lastSeenBeacon.proximity]);
            }
        }
    }
}


- (NSString *)nameForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            return @"Unknown";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityFar:
            return @"Far";
            break;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table view delegate Method starts

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeaconItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    BeaconItem *item = self.items[indexPath.row];
    //cell.item = item;
    //cell.detailTextLabel.text = self.titlee;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",item.name,[self nameForProximity:item.lastSeenBeacon.proximity]];
    
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BeaconItem *itemToRemove = [self.items objectAtIndex:indexPath.row];
        [self stopMonitoringItem:itemToRemove];
        
        [tableView beginUpdates];
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        [self persistItems];
        
        if(self.items.count <=0)
        {
            self.title = @"Smyrilline - Beacon";
            
            appDelegate.beaconStatusArray = [NSMutableArray new];
        }
    }
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"details" sender:self];
    
    
}

#pragma mark Table view delegate method ends



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
