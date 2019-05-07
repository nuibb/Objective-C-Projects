//
//  BeaconItemTableViewCell.m
//  MCP
//
//  Created by Rafay Hasan on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "BeaconItemTableViewCell.h"
#import "BeaconItem.h"
@implementation BeaconItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setItem:(BeaconItem *)item {
    if (_item) {
        [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
    }
    
    _item = item;
    [_item addObserver:self forKeyPath:@"lastSeenBeacon" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.textLabel.text = _item.name;
}

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.item] && [keyPath isEqualToString:@"lastSeenBeacon"]) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"Location: %@", [self nameForProximity:self.item.lastSeenBeacon.proximity]];
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
