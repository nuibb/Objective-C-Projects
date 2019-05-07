//
//  beaconDetectViewController.m
//  iBeacon Example
//
//  Created by Rafay Hasan on 5/26/15.
//  Copyright (c) 2015 Rafay Hasan. All rights reserved.
//

#import "beaconDetectViewController.h"
#import "BeaconItem.h"
#import "AddBeaconViewController.h"
@import CoreLocation;

NSString * const kRWTStoredItemsKey = @"storedItems";

@interface beaconDetectViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *beaconStatusLabel;





- (IBAction)beaconItemAddButtonAction:(id)sender;


@end

@implementation beaconDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self loadItems];
}

- (void)loadItems {
    NSArray *storedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kRWTStoredItemsKey];
    self.items = [NSMutableArray array];
    
    if (storedItems) {
        for (NSData *itemData in storedItems) {
            BeaconItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
            [self.items addObject:item];
            [self startMonitoringItem:item];
        }
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
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    NSLog(@"Detected");
}

- (void)stopMonitoringItem:(BeaconItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
     NSLog(@"Hello %lu",(unsigned long)beacons.count);
    
    
    NSLog(@"item count is %lu",(unsigned long)self.items.count);
    
    for (CLBeacon *beacon in beacons) {
        for (BeaconItem *item in self.items) {
            if ([item isEqualToCLBeacon:beacon])
            {
                item.lastSeenBeacon = beacon;
                
                NSString *proximity = [self nameForProximity:item.lastSeenBeacon.proximity];
                
               // NSLog(@"item uuid %@ major id %i minor id %i",item.uuid,item.majorValue,item.minorValue);
                
                //NSLog(@"last seen location is %@",[NSString stringWithFormat:@"Location: %@", proximity]);
                
                self.beaconStatusLabel.text = [NSString stringWithFormat:@"Beacon name is %@ and location is %@",item.name,proximity];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)beaconItemAddButtonAction:(id)sender {
    
    AddBeaconViewController *vc = [AddBeaconViewController new];
    
    [vc setItemAddedCompletion:^(BeaconItem *newItem) {
        [self.items addObject:newItem];
        [self startMonitoringItem:newItem];
        [self persistItems];
    }];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}
@end
