//
//  RegistrationController.m
//  bdipo
//
//  Created by Nascenia on 4/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RegistrationController.h"
#import "SectionHeaderView.h"
#import "SectionInfo.h"
#import "CustomCellWithImage.h"
#import "CustomCellWithText.h"
#import "GetServices.h"
#import "Settings.h"
#import "RegistrationCustomCell.h"
#import "RegisterWithPayment.h"

@interface RegistrationController ()
@property GetServices *getService;
@property Settings *settings;
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) IBOutlet SectionHeaderView *sectionHeaderView;
@property NSInteger selectedSectionIndex;
@property (atomic) BOOL isTrialAccount;
@end

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

#define DEFAULT_CUSTOM_HEIGHT 100
#define DEFAULT_ROW_HEIGHT 48

@implementation RegistrationController

- (void) getDataForChoosePlan{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"CatagoryToChoosePlan" withExtension:@"plist"];
    NSArray *planDictionaryArray = [[NSArray alloc ] initWithContentsOfURL:url];
    
    if ((self.sectionInfoArray == nil) ||
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
        
        //For each IPO, set up a corresponding SectionInfo object.
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        for (NSDictionary *plan in planDictionaryArray) {
            SectionInfo *section = [[SectionInfo alloc] init];
            section.open = NO;
            if (plan[@"planName"] && plan[@"planArray"]) {
                section.name = plan[@"planName"];
                section.rowInfoArray = plan[@"planArray"];
                [infoArray addObject:section];
            }
        }
        self.sectionInfoArray = infoArray;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    self.tableView.sectionHeaderHeight = DEFAULT_ROW_HEIGHT;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExpandableSectionView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    //Get data for a plan from .plist file
    [self getDataForChoosePlan];
    self.openSectionIndex = NSNotFound;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionInfoArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SectionInfo *_section = (self.sectionInfoArray)[section];
    return _section.open ? [_section.rowInfoArray count] : 0;
}

-(void) btnClickListener:(NSString *)sender{
    self.isTrialAccount = NO;
    UIButton *clicked = (UIButton *) sender;
    self.selectedSectionIndex = clicked.tag;
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CustomCellWithText *cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithText"];
        
        SectionInfo *_section = (self.sectionInfoArray)[indexPath.section];
        cell.label1.text = _section.rowInfoArray[indexPath.row][@"title"];
        cell.label2.text = _section.rowInfoArray[indexPath.row][@"value"];
        
        return cell;
    }else if(indexPath.row == 7){
        RegistrationCustomCell *cell = [[RegistrationCustomCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"RegisterCell"];
        
        SectionInfo *_section = (self.sectionInfoArray)[indexPath.section];
        cell.label1.text = _section.rowInfoArray[indexPath.row][@"title"];
        cell.label2.text = _section.rowInfoArray[indexPath.row][@"value"];
        
        cell.registerBtn.tag = indexPath.section;
        [cell.registerBtn addTarget:self action:@selector(btnClickListener:) forControlEvents:UIControlEventTouchUpInside];
        
        //cell.delegate = self;
        return cell;
    }
    else{
        CustomCellWithImage *cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithImage" forIndexPath:indexPath];
        
        SectionInfo *_section = (self.sectionInfoArray)[indexPath.section];
        cell.label.text = _section.rowInfoArray[indexPath.row][@"title"];
        if (_section.rowInfoArray[indexPath.row][@"value"]) {
            [cell.image setImage:[UIImage imageNamed: _section.rowInfoArray[indexPath.row][@"value"]]];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        return DEFAULT_CUSTOM_HEIGHT;
    }else{
        return DEFAULT_ROW_HEIGHT;
    }
}

/*-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return [NSString stringWithFormat:@"%@%ld", @"Section ", (long)section];
 }*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    SectionInfo *_section = (self.sectionInfoArray)[section];
    _section.headerView = sectionHeaderView;
    sectionHeaderView.titleLabel.text = _section.name;
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
    NSInteger countOfRowsToInsert = [sectionInfo.rowInfoArray count];
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
        NSInteger countOfRowsToDelete = [previousOpenSection.rowInfoArray count];
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

/*-(void)goToPaymentSelection:(NSInteger)section{
 NSLog(@"Clicked");
 //[self performSegueWithIdentifier:@"showIPOResult" sender:nil];
 }*/



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RegisterWithPayment *vc = [segue destinationViewController];
    SectionInfo *sectionInfo = (self.sectionInfoArray)[self.selectedSectionIndex];
    vc.planType = self.isTrialAccount ? @"Trial" : sectionInfo.name;
    vc.isTrialAccount = self.isTrialAccount;
}

- (IBAction)tryForFreeListener:(id)sender {
    self.isTrialAccount = YES;
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

@end
