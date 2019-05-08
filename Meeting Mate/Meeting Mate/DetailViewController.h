//
//  DetailViewController.h
//  Meeting Mate
//
//  Created by Ashik Mahmud on 8/4/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//
#import <PSPDFKit/PSPDFKit.h>

#import <UIKit/UIKit.h>
//#import <PlugPDF/PlugPDF.h>
//#import "PlugPDF/DocumentViewController.h"
//#import "PlugPDF/Document.h"
#import "MasterViewController.h"

@protocol DelegateForPassDataToMasterView;

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *navigationTitle;
@property (strong, nonatomic) NSString *mom;
@property (strong, nonatomic) NSArray *agendaList;
@property (strong, nonatomic) NSMutableArray *oldMeetingList;
@property (strong, nonatomic) NSMutableArray *futureMeetingList;

@property (strong, nonatomic) MasterViewController *masterViewController;
@property (nonatomic, weak) id<DelegateForPassDataToMasterView> delegate;

@end

@protocol DelegateForPassDataToMasterView <NSObject>

-(void) getDataFromDelegateFunc:(NSInteger)_id toType:(NSString *)type;

@optional
- (void)getRowID:(NSString *)_id;

@end


