//
//  MasterViewController.m
//  Meeting Mate
//
//  Created by Ashik Mahmud on 8/4/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SectionHeaderView.h"
#import "LogOutController.h"
#import "ShowAlert.h"

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface MasterViewController () <DelegateForPassDataToMasterView>

@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) ShareInfoCell *shareInfo;
@property (strong, nonatomic) NSMutableArray *oldMeetingArray;
@property (strong, nonatomic) NSMutableArray *futureMeetingArray;
@property (strong, nonatomic) NSMutableArray *participantsArray;
@property (strong, nonatomic) NSMutableArray *memberEmailList;
@property (strong, nonatomic) NSMutableArray *filterArrayForFutureMeeting;
@property (strong, nonatomic) NSMutableArray *filterArrayForOldMeeting;
@property (strong, nonatomic) NSMutableDictionary *membersDictionary;
@property BOOL showMeetingInfo;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void) meetingInfoHasBeenUpdated:(NSDictionary *)meeting_info {
    //NSLog(@"Meeting Info  :  %@", meeting_info);
    
    if ([meeting_info objectForKey:@"future_date"]) {
        self.futureMeetingArray = [meeting_info objectForKey:@"future_date"];
    }
    
    if ([meeting_info objectForKey:@"old_date"]) {
        self.oldMeetingArray = [meeting_info objectForKey:@"old_date"];
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    });
}

- (void) getMeetingParticipants:(NSDictionary *)participantsInfo {
    
    if ([participantsInfo objectForKey:@"perticiant"]) {
        
        self.participantsArray = [participantsInfo objectForKey:@"perticiant"];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (self.oldMeetingArray.count != 0 && self.futureMeetingArray.count != 0) {
            
            if (indexPath.section) {
                
                NSDictionary *object = [self.oldMeetingArray objectAtIndex:indexPath.row];
                [self.membersDictionary setObject:self.participantsArray forKey:[object objectForKey:@"meeting_id"]];
            } else {
                
                NSDictionary *object = [self.futureMeetingArray objectAtIndex:indexPath.row];
                [self.membersDictionary setObject:self.participantsArray forKey:[object objectForKey:@"meeting_id"]];
            }
        } else if (self.oldMeetingArray.count != 0) {
            
            NSDictionary *object = [self.oldMeetingArray objectAtIndex:indexPath.row];
            [self.membersDictionary setObject:self.participantsArray forKey:[object objectForKey:@"meeting_id"]];
        } else if (self.futureMeetingArray.count != 0) {
            
            NSDictionary *object = [self.futureMeetingArray objectAtIndex:indexPath.row];
            [self.membersDictionary setObject:self.participantsArray forKey:[object objectForKey:@"meeting_id"]];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
        });
    }
}

-(void) setShareBtnAsRightNavigationBtn {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"shareBtn.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareBtnClickListener:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    rightButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void) logOutBtnClick {
    
    LogOutController *controller = [[LogOutController alloc] init];
    UIAlertController *_actionController = [controller getActionSheet];
    UIPopoverPresentationController *popover = _actionController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.sourceRect = self.view.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:_actionController animated:YES completion:nil];
}

-(void) setLogoutBtnAsLeftNavigationBtn {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"logOut.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void) addSearchBarAsTableViewHeader {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Make sure the that the search bar is visible within the navigation bar.
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Meeting Search";
    
    // Include the search controller's search bar within the table's header view.
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}

- (void) getDataFromDelegateFunc:(NSInteger)index toType:(NSString *)type {
    
    if (self.searchController.active) {
        
        [self.searchController setActive:NO];
    } else {
        if (!_showMeetingInfo) {
            _showMeetingInfo = YES;
            [self.tableView reloadData];
        }
    }
    
    NSIndexPath *indexPath;
    NSIndexPath *prevSelectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    if ([type isEqualToString:@"old"]) {
        indexPath = [NSIndexPath indexPathForRow:index inSection:[self.tableView numberOfSections] == 2 ? 1 : 0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
    [self.tableView deselectRowAtIndexPath:prevSelectedIndexPath animated:YES];
    [self tableView:self.tableView didDeselectRowAtIndexPath:prevSelectedIndexPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:63.0/255.0 green:188.0/255.0 blue:206.0/255.0 alpha:1];
    
    [self setLogoutBtnAsLeftNavigationBtn];
    [self setShareBtnAsRightNavigationBtn];
    [self addSearchBarAsTableViewHeader];
    
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityIndicator setColor:[UIColor purpleColor]];
    
    self.participantsArray = [[NSMutableArray alloc] init];
    self.memberEmailList = [[NSMutableArray alloc] init];
    self.membersDictionary = [[NSMutableDictionary alloc] init];
    self.tableView.sectionHeaderHeight = 70;
    self.tableView.rowHeight = 70;
    
    self.showMeetingInfo = YES;
    self.dataManager = [DataManager new];
    self.dataManager.delegate = self;
    self.dataManager.delegate1 = self;
    [self.dataManager getMeetingInfos];
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExpandableSectionView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //self.detailViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active) {
        if (self.filterArrayForFutureMeeting.count != 0 && self.filterArrayForOldMeeting.count != 0) {
            return 2;
        } else if (self.filterArrayForFutureMeeting.count != 0 || self.filterArrayForOldMeeting.count != 0) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if (_showMeetingInfo) {
            if (self.futureMeetingArray.count != 0 && self.oldMeetingArray.count != 0) {
                return 2;
            } else if (self.futureMeetingArray.count != 0 || self.oldMeetingArray.count != 0) {
                return 1;
            } else {
                return 0;
            }
        } else {
            if (self.participantsArray.count != 0) {
                return 2;
            } else {
                return 0;
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        
        if (self.filterArrayForFutureMeeting.count != 0 && self.filterArrayForOldMeeting.count != 0) {
            if (section == 0) {
                return self.filterArrayForFutureMeeting.count;
            } else {
                return self.filterArrayForOldMeeting.count;
            }
        } else if (self.filterArrayForFutureMeeting.count != 0) {
            return self.filterArrayForFutureMeeting.count;
        } else if (self.filterArrayForOldMeeting.count != 0) {
            return self.filterArrayForOldMeeting.count;
        }
    } else {
        if (_showMeetingInfo) {
            if (self.futureMeetingArray.count != 0 && self.oldMeetingArray.count != 0) {
                if (section==0) {
                    return [self.futureMeetingArray count];
                } else if (section==1) {
                    return [self.oldMeetingArray count];
                }
            } else if (self.futureMeetingArray.count != 0) {
                return [self.futureMeetingArray count];
            } else if (self.oldMeetingArray.count != 0) {
                return [self.oldMeetingArray count];
            }
            
        } else {
            if (section) {
                return 1;
            } else {
                return [self.participantsArray count];
            }
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (self.searchController.active) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor colorWithRed:54.0/255.0 green:61.0/255.0 blue:70.0/255.0 alpha:1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor colorWithRed:74.0/255.0 green:82.0/255.0 blue:94.0/255.0 alpha:1.0];
        
        NSDictionary *object;
        if (self.filterArrayForFutureMeeting.count != 0 && self.filterArrayForOldMeeting.count != 0) {
            if (indexPath.section==0) {
                object = [self.filterArrayForFutureMeeting objectAtIndex:indexPath.row];
            } else if (indexPath.section==1) {
                object = [self.filterArrayForOldMeeting objectAtIndex:indexPath.row];
            }
        } else if (self.filterArrayForFutureMeeting.count != 0){
            object = [self.filterArrayForFutureMeeting objectAtIndex:indexPath.row];
        } else if (self.filterArrayForOldMeeting.count != 0){
            object = [self.filterArrayForOldMeeting objectAtIndex:indexPath.row];
        }
        
        cell.textLabel.text= [object objectForKey:@"title"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text= [object objectForKey:@"meeting_date"];
        cell.detailTextLabel.textColor=[UIColor colorWithRed:63.0/255.0 green:188.0/255.0 blue:206.0/255.0 alpha:1];
        
        return cell;
        
    } else {
        if (_showMeetingInfo) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.backgroundColor=[UIColor colorWithRed:54.0/255.0 green:61.0/255.0 blue:70.0/255.0 alpha:1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.tableView.separatorColor = [UIColor colorWithRed:74.0/255.0 green:82.0/255.0 blue:94.0/255.0 alpha:1.0];
            
            NSDictionary *object;
            if (self.futureMeetingArray.count != 0 && self.oldMeetingArray.count != 0) {
                if (indexPath.section==0) {
                    
                    if(indexPath.row == 0) {
                        
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
                        cell.backgroundColor = [UIColor colorWithRed: 63.0f/255.0f green:188.0f/255.0f blue:206.0f/255.0f alpha:1.0];
                        
                    }
                    
                    object = [self.futureMeetingArray objectAtIndex:indexPath.row];
                } else if (indexPath.section==1) {
                    object = [self.oldMeetingArray objectAtIndex:indexPath.row];
                }
            } else if (self.futureMeetingArray.count != 0){
                object = [self.futureMeetingArray objectAtIndex:indexPath.row];
            } else if (self.oldMeetingArray.count != 0){
                object = [self.oldMeetingArray objectAtIndex:indexPath.row];
            }
            
            cell.textLabel.text= [object objectForKey:@"title"];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.text= [object objectForKey:@"meeting_date"];
            cell.detailTextLabel.textColor=[UIColor colorWithRed:63.0/255.0 green:188.0/255.0 blue:206.0/255.0 alpha:1];
            
            return cell;
            
        } else {
            if (indexPath.section) {
                ShareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCustomCell" forIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            } else {
                UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
                cell.backgroundColor=[UIColor colorWithRed:54.0/255.0 green:61.0/255.0 blue:70.0/255.0 alpha:1];
                
                NSDictionary *participant = [self.participantsArray objectAtIndex:indexPath.row];
                if ([participant objectForKey:@"image"]) {
                    NSString *imgURL = [participant objectForKey:@"image"];
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
                    [cell.leftImage setImage:[UIImage imageWithData:data]];
                } else {
                    [cell.leftImage setImage:[UIImage imageNamed:@"defaultImage"]];
                }
                
                cell.name.text = [participant objectForKey:@"name"];
                cell.name.textColor = [UIColor whiteColor];
                return cell;
            }
        }
    }
    
    return cell;
}

-(BOOL) checkIfEmailAlreadyExist:(NSString *)email {
    if ([self.memberEmailList containsObject:email]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.searchController.active) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath] ;
        cell.backgroundColor = [UIColor colorWithRed: 63.0f/255.0f green:188.0f/255.0f blue:206.0f/255.0f alpha:1.0];
        
        if (!_showMeetingInfo && !indexPath.section) {
            if (self.participantsArray.count != 0) {
                NSDictionary *participant = [self.participantsArray objectAtIndex:indexPath.row];
                if ([self checkIfEmailAlreadyExist:[participant objectForKey:@"email"]]) {
                    [self.memberEmailList removeObject:[participant objectForKey:@"email"]];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                } else {
                    [self.memberEmailList addObject:[participant objectForKey:@"email"]];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchController.active) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath] ;
        cell.backgroundColor = [UIColor colorWithRed: 54.0f/255.0f green:61.0f/255.0f blue:70.0f/255.0f alpha:1.0];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    if (self.searchController.active) {
        if (self.filterArrayForFutureMeeting.count != 0 && self.filterArrayForOldMeeting.count != 0) {
            if (section==0) {
                sectionHeaderView.label.text = @"Upcoming Meetings";
            } else if (section==1) {
                sectionHeaderView.label.text = @"Preceding Meetings";
            }
            return sectionHeaderView;
        } else if (self.filterArrayForFutureMeeting.count != 0) {
            sectionHeaderView.label.text = @"Upcoming Meetings";
            return sectionHeaderView;
        } else if (self.filterArrayForOldMeeting.count != 0) {
            sectionHeaderView.label.text = @"Preceding Meetings";
            return sectionHeaderView;
        }
        
    } else {
        if (_showMeetingInfo) {
            if (self.futureMeetingArray.count != 0 && self.oldMeetingArray.count != 0) {
                if (section==0) {
                    sectionHeaderView.label.text = @"Upcoming Meetings";
                } else if (section==1) {
                    sectionHeaderView.label.text = @"Preceding Meetings";
                }
                return sectionHeaderView;
            } else if (self.futureMeetingArray.count != 0) {
                sectionHeaderView.label.text = @"Upcoming Meetings";
                return sectionHeaderView;
            } else if (self.oldMeetingArray.count != 0) {
                sectionHeaderView.label.text = @"Preceding Meetings";
                return sectionHeaderView;
            }
        } else {
            if (!section) {
                sectionHeaderView.label.text = @"Members List";
                return sectionHeaderView;
            }
        }
    }
    
    return nil;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 UIView *overlayView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
 overlayView.backgroundColor=[UIColor blueColor];
 return overlayView;
 }*/

-(void)filterContentForSearchText:(NSString*) searchText {
    
    [self.filterArrayForFutureMeeting removeAllObjects];
    [self.filterArrayForOldMeeting removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", searchText];
    
    //Add matching object from future meeting to show in search table
    self.filterArrayForFutureMeeting = [NSMutableArray arrayWithArray:[self.futureMeetingArray filteredArrayUsingPredicate:predicate]];
    
    //Add matching object from old meeting to show in search table
    self.filterArrayForOldMeeting = [NSMutableArray arrayWithArray:[self.oldMeetingArray filteredArrayUsingPredicate:predicate]];
    
    [self.tableView reloadData];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (self.oldMeetingArray.count != 0 || self.futureMeetingArray.count !=0) {
        
        NSString *trimmedText = [searchController.searchBar.text stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
        
        if (![trimmedText isEqualToString:@""]) {
            [self filterContentForSearchText:trimmedText];
        }
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.filterArrayForFutureMeeting = [NSMutableArray arrayWithArray:self.futureMeetingArray];
    //Add matching object from old meeting to show in search table
    self.filterArrayForOldMeeting = [NSMutableArray arrayWithArray:self.oldMeetingArray];
    
    [self.tableView reloadData];
}

#pragma mark - Segues

-(void) passDataThroughSegue: (DetailViewController *)controller meetingObj:(NSDictionary *) meeting {
    controller.navigationTitle = [meeting objectForKey:@"title"];
    controller.mom = [meeting objectForKey:@"file_path"];
    
    NSArray *agenda = [meeting objectForKey:@"agenda"];
    controller.agendaList = agenda;
    if (agenda.count == 0) {
        [ShowAlert alertWithMessage:@"Message!" message:@"Currently there is no agenda for this meeting."];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.oldMeetingList = self.oldMeetingArray;
        controller.futureMeetingList = self.futureMeetingArray;
        
        if (self.searchController.active) {
            if (self.filterArrayForFutureMeeting.count != 0 && self.filterArrayForOldMeeting.count != 0) {
                if (indexPath.section) {
                    NSDictionary *meeting = self.filterArrayForOldMeeting[indexPath.row];
                    [self passDataThroughSegue:controller meetingObj:meeting];
                } else {
                    NSDictionary *meeting = self.filterArrayForFutureMeeting[indexPath.row];
                    [self passDataThroughSegue:controller meetingObj:meeting];
                }
            } else if (self.filterArrayForFutureMeeting.count != 0) {
                NSDictionary *meeting = self.filterArrayForFutureMeeting[indexPath.row];
                [self passDataThroughSegue:controller meetingObj:meeting];
            } else if (self.filterArrayForOldMeeting.count != 0) {
                NSDictionary *meeting = self.filterArrayForOldMeeting[indexPath.row];
                [self passDataThroughSegue:controller meetingObj:meeting];
            }
        } else {
            if (self.futureMeetingArray.count != 0 && self.oldMeetingArray.count != 0) {
                if (indexPath.section) {
                    NSDictionary *meeting = self.oldMeetingArray[indexPath.row];
                    [self passDataThroughSegue:controller meetingObj:meeting];
                } else {
                    NSDictionary *meeting = self.futureMeetingArray[indexPath.row];
                    [self passDataThroughSegue:controller meetingObj:meeting];
                }
            } else if (self.futureMeetingArray.count != 0) {
                NSDictionary *meeting = self.futureMeetingArray[indexPath.row];
                [self passDataThroughSegue:controller meetingObj:meeting];
            } else if (self.oldMeetingArray.count != 0) {
                NSDictionary *meeting = self.oldMeetingArray[indexPath.row];
                [self passDataThroughSegue:controller meetingObj:meeting];
            }
        }
    }
}

- (IBAction)shareBtnClickListener:(id)sender {
    _showMeetingInfo = NO;
    self.navigationItem.title = @"Members";
    
    if (!self.searchController.active) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (self.futureMeetingArray.count != 0 && self.oldMeetingArray.count != 0) {
            if (indexPath.section) {
                NSDictionary *object = [self.oldMeetingArray objectAtIndex:indexPath.row];
                if ([self checkObjIfExistsByMeetingId:[object objectForKey:@"meeting_id"]]) {
                    self.participantsArray = [self.membersDictionary objectForKey:[object objectForKey:@"meeting_id"]];
                    [self.tableView reloadData];
                } else {
                    [self.activityIndicator startAnimating];
                    self.activityIndicator.hidden = NO;
                    [self.dataManager getMeetingParticipantsList:[object objectForKey:@"meeting_id"]];
                }
            } else {
                NSDictionary *object = [self.futureMeetingArray objectAtIndex:indexPath.row];
                if ([self checkObjIfExistsByMeetingId:[object objectForKey:@"meeting_id"]]) {
                    self.participantsArray = [self.membersDictionary objectForKey:[object objectForKey:@"meeting_id"]];
                    [self.tableView reloadData];
                } else {
                    [self.activityIndicator startAnimating];
                    self.activityIndicator.hidden = NO;
                    [self.dataManager getMeetingParticipantsList:[object objectForKey:@"meeting_id"]];
                }
            }
        } else if (self.futureMeetingArray.count != 0) {
            NSDictionary *object = [self.futureMeetingArray objectAtIndex:indexPath.row];
            if ([self checkObjIfExistsByMeetingId:[object objectForKey:@"meeting_id"]]) {
                self.participantsArray = [self.membersDictionary objectForKey:[object objectForKey:@"meeting_id"]];
                [self.tableView reloadData];
            } else {
                [self.activityIndicator startAnimating];
                self.activityIndicator.hidden = NO;
                [self.dataManager getMeetingParticipantsList:[object objectForKey:@"meeting_id"]];
            }
        } else if (self.oldMeetingArray.count != 0) {
            NSDictionary *object = [self.oldMeetingArray objectAtIndex:indexPath.row];
            if ([self checkObjIfExistsByMeetingId:[object objectForKey:@"meeting_id"]]) {
                self.participantsArray = [self.membersDictionary objectForKey:[object objectForKey:@"meeting_id"]];
                [self.tableView reloadData];
            } else {
                [self.activityIndicator startAnimating];
                self.activityIndicator.hidden = NO;
                [self.dataManager getMeetingParticipantsList:[object objectForKey:@"meeting_id"]];
            }
        }
    }
}

-(BOOL) checkObjIfExistsByMeetingId:(NSString *)_id {
    if ([[self.membersDictionary allKeys] containsObject:_id]) {
        return YES;
    } else {
        return NO;
    }
}

-(void) shareMeetingInfoToParticipants {
    if (self.memberEmailList.count != 0) {
        [self displayMailComposerSheet:self.memberEmailList];
    } else {
        [ShowAlert alertWithMessage:@"Message!" message:@"Please select at least one member to send mail."];
    }
}

-(void) cancelSharingMeetingInfo {
    _showMeetingInfo = YES;
    self.navigationItem.title = @"Meetings";
    [self.tableView reloadData];
}

#pragma mark - Refresh master view selecting meeting for detail view's agenda


#pragma mark - Mail Composer Sheet

- (void)displayMailComposerSheet:(NSArray *)toRecipients {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setToRecipients:toRecipients];
    [picker setSubject:@""];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result){
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            [ShowAlert alertWithMessage:@"Message!" message:@"Mail has been saved"];
            break;
        case MFMailComposeResultSent:
            [ShowAlert alertWithMessage:@"Message!" message:@"Mail has been sent successfully."];
            _showMeetingInfo = YES;
            self.navigationItem.title = @"Meetings";
            [self.tableView reloadData];
            break;
        case MFMailComposeResultFailed:
            [ShowAlert alertWithMessage:@"Warnings" message:@"Mail sending failed"];
            break;
        default:
            [ShowAlert alertWithMessage:@"Warnings" message:@"Mail can not be sent"];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.dataManager getMeetingInfos];

}

@end
