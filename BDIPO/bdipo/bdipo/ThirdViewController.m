//
//  ThirdViewController.m
//  bdipo
//
//  Created by Nascenia on 3/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "ThirdViewController.h"
#import "SectionHeaderView.h"
#import "SectionInfo.h"
#import "ExpandableCell.h"
#import "GetServices.h"
#import "Settings.h"

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface ThirdViewController ()
@property GetServices *getService;
@property Settings *settings;
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSMutableArray *rowInfoArrayForTitle;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) IBOutlet SectionHeaderView *sectionHeaderView;
@end

#pragma mark -

#define DEFAULT_Section_HEIGHT 100
#define DEFAULT_ROW_HEIGHT 48

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Do any additional setup after loading the view.
    self.openSectionIndex = NSNotFound;
    
    //Set up default values.
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.sectionHeaderHeight = DEFAULT_ROW_HEIGHT;
    self.tableView.rowHeight = DEFAULT_ROW_HEIGHT;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExpandableSectionView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

- (void)loadSectionInfo:(NSDictionary *)sectionsInfoArray {
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
    if ((self.sectionInfoArray == nil) ||
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
        
        //For each IPO, set up a corresponding SectionInfo object.
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *rowInfo in sectionsInfoArray) {
            SectionInfo *sectionInfo = [[SectionInfo alloc] init];
            NSMutableArray *rowsInfoArray = [[NSMutableArray alloc] init];
            sectionInfo.open = NO;
            sectionInfo.name = rowInfo[@"name"];
            
            if (rowInfo[@"subscription_open_date"]) {
                [rowsInfoArray addObject:rowInfo[@"subscription_open_date"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"subscription_close_date"]) {
                [rowsInfoArray addObject:rowInfo[@"subscription_close_date"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"nrb_subscription_close_date"]) {
                [rowsInfoArray addObject:rowInfo[@"nrb_subscription_close_date"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"market_lot"]) {
                [rowsInfoArray addObject:rowInfo[@"market_lot"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"face_value"]) {
                [rowsInfoArray addObject:rowInfo[@"face_value"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"premium"]) {
                [rowsInfoArray addObject:rowInfo[@"premium"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"eps"]) {
                [rowsInfoArray addObject:rowInfo[@"eps"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"nav"]) {
                [rowsInfoArray addObject:rowInfo[@"nav"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"public_offer"]) {
                [rowsInfoArray addObject:rowInfo[@"public_offer"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"major_product"]) {
                [rowsInfoArray addObject:rowInfo[@"major_product"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            if (rowInfo[@"manager_to_the_issue"]) {
                [rowsInfoArray addObject:rowInfo[@"manager_to_the_issue"]];
            }else{
                [rowsInfoArray addObject:@""];
            }
            
            sectionInfo.rowInfoArray = rowsInfoArray;
            [infoArray addObject:sectionInfo];
        }
        self.sectionInfoArray = infoArray;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.settings = [[Settings alloc]init];
    self.getService = [[GetServices alloc]init];
    self.rowInfoArrayForTitle = [[NSMutableArray alloc] initWithObjects:@"Subscription Starts", @"Subscription End", @"NRB Subscription Ends", @"Market Lot", @"Face Value", @"Premium", @"EPS", @"NAV", @"Public Offer", @"Major Product", @"Issue Manager", nil];
    
    [self.getService apiCallToGet:[self.settings getUpcomingIPO] callback:^(NSDictionary *response){
        if ([response count]) {
            [self loadSectionInfo:response];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionInfoArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    return sectionInfo.open ? [self.rowInfoArrayForTitle count] : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpandableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *rowTitle = self.rowInfoArrayForTitle[indexPath.row];
    cell.title.text = rowTitle;
    
    NSMutableArray *rowInfo = [self.sectionInfoArray[indexPath.section] rowInfoArray];
    id object = rowInfo[indexPath.row];
    
    if (![object isEqual:[NSNull null]]) {
        if ([object isKindOfClass:[NSString class]]){
            cell.value.text = object;
        }else{
            cell.value.text = [object stringValue];
        }
    }else{
        cell.value.text = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    SectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    sectionHeaderView.titleLabel.text = sectionInfo.name;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}


#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    SectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [self.rowInfoArrayForTitle count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        SectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [self.rowInfoArrayForTitle count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    SectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
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
