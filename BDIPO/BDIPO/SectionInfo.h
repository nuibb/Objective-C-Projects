//
//  SectionInfo.h
//  DemmoOBJ-C
//
//  Created by Nascenia on 3/18/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionHeaderView.h"

@interface SectionInfo : NSObject

@property (getter = isOpen) BOOL open;
@property NSMutableArray *rowInfoArray;
@property (nonatomic, strong) NSString *name;
@property SectionHeaderView *headerView;

@end
