//
//  DetailViewController.m
//  Meeting Mate
//
//  Created by Ashik Mahmud on 8/4/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomCellForDetailView.h"
#import "AFHTTPSessionManager.h"
#import "ShowAlert.h"

@interface DetailViewController () {
    
    NSMutableData *responsedata;
    NSString *pdfFilePath;
    
    //for bundle
    NSArray *paths;
    NSString* documentsDirectory;
    
}

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *filterArray;
@property (nonatomic, strong) NSProgress *progress;

@property BOOL isSearchControllerActive;

@end

@implementation DetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.progress = [NSProgress new];
        [self.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (void) dealloc {
    [self.progress removeObserver:self forKeyPath:@"fractionCompleted"];
}

#pragma mark - Managing the detail item

-(void) momBtnClick {
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[_mom lastPathComponent]];
    pdfFilePath=[_mom lastPathComponent];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self openPlugPDF];
    } else {
        [self presentViewController:[self showAlertForPdfDownload:[_mom lastPathComponent] path:_mom andPopUpText:@"Do you want to download this pdf file ?"] animated:YES completion:nil];
    }
}

-(void) setMomImageAsLeftNavigationBtn {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"momIcon.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(momBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    _isSearchControllerActive = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.filterArray removeAllObjects];
    _isSearchControllerActive = NO;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void) addSearchBarAsTableViewHeader {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Make sure the that the search bar is visible within the navigation bar.
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Agenda Search";
    
    // Include the search controller's search bar within the table's header view.
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isSearchControllerActive = NO;
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
    _activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.height/2 - 40 , [[UIScreen mainScreen]bounds].size.width/2 - 100);
    _activityIndicator.hidden=YES;
    [_activityIndicator setColor:[UIColor purpleColor]];
    [self.view addSubview:_activityIndicator];
    
    // get the first object in the split view
    self.masterViewController = (MasterViewController *)[[self.splitViewController.viewControllers firstObject] topViewController];
    
    // assign the delegate as it
    _delegate = (id)_masterViewController;
    
    self.tableView.rowHeight = 100.0;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:63.0/255.0 green:188.0/255.0 blue:206.0/255.0 alpha:1];
    [self addSearchBarAsTableViewHeader];
    
    self.filterArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = self.navigationTitle;
    
    if (_mom) {
        [self setMomImageAsLeftNavigationBtn];
    }
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isSearchControllerActive) {
        return self.filterArray.count;
    } else {
        return self.agendaList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCellForDetailView *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
   
    
    if (indexPath.row % 2 ==0) {
        cell.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:219.0f/255.0f blue:220.0f/255.0f alpha:1.0];
    }
    
    NSDictionary *agenda;
    
    if (_isSearchControllerActive) {
        agenda = self.filterArray[indexPath.row];
    } else {
        agenda = self.agendaList[indexPath.row];
    }
    
    cell.label.text = [agenda objectForKey:@"agenda"];
    
    cell.tag = [[agenda objectForKey:@"id"] integerValue];
    
    if (![agenda objectForKey:@"file"]) {
        cell.pdfImage.image = nil;
    } else {
        [cell.pdfImage setImage:[UIImage imageNamed:@"pdfIcon"]];
    }
    
    return cell;
}


- (void)openPlugPDF {
    
    NSString * path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, pdfFilePath];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:path]];
    PSPDFViewController *viewController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.thumbnailBarMode = PSPDFThumbnailBarModeNone;
        builder.shouldShowHUDOnViewWillAppear = NO;
        builder.pageLabelEnabled = NO;
        
    }]];
    
    if (viewController) {
        [viewController.view setFrame:CGRectMake(20, 20, 300, 200)];
        [self.navigationController pushViewController: viewController
                                             animated: YES];
        
        if ([[UIDevice currentDevice].systemVersion hasPrefix:@"7"] ||
            [[UIDevice currentDevice].systemVersion hasPrefix:@"8"]) {
            [viewController setAutomaticallyAdjustsScrollViewInsets: NO];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        
        NSLog(@"%f", self.progress.fractionCompleted * 100.0);
        
    }
}


-(void) downloadPdfFile: (NSString *)pdfPath {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    self.progress.totalUnitCount =  1;
    self.progress.completedUnitCount = 0;
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    [self.view setUserInteractionEnabled:NO];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pdfPath]];
    
    NSURLSessionTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory,[pdfFilePath lastPathComponent]]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [self.view setUserInteractionEnabled:YES];
                [self presentViewController:[self showAlertForPdfDownload:@"" path:@"" andPopUpText:@"Error In Downloading PDF"] animated:YES completion:nil];
                
            } else {
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [self.view setUserInteractionEnabled:YES];
                [self openPlugPDF];
                
            }
        });
    }];
    
    NSProgress *childProgress = [manager downloadProgressForTask:task];
    [self.progress addChild:childProgress withPendingUnitCount:1];
    
    
    [task resume];
}

-(UIAlertController *) showAlertForPdfDownload: (NSString *)pdfName path:(NSString *) pdfPath andPopUpText:(NSString *)popUpText {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:popUpText message:pdfName preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *rightBtnText = [popUpText containsString:@"Error"]?@"Ok" : @"Download";
    UIAlertAction *downloadPdf = [UIAlertAction actionWithTitle:rightBtnText style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        if(![popUpText containsString:@"Error"]) {
            
            [self.searchController setActive:NO];
            [self downloadPdfFile:pdfPath];
        }
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:downloadPdf];
    [alertController addAction:cancel];
    
    return alertController;
}


-(void) getMeetingID:(NSString *)_id {
    
    for (NSInteger i=0, j= self.futureMeetingList.count; i<j; i++) {
        NSArray *agendaList = [self.futureMeetingList[i] objectForKey:@"agenda"];
        if (agendaList.count != 0) {
            for (NSDictionary *agenda in agendaList) {
                if ([_id isEqualToString:[agenda objectForKey:@"id"]]) {
                    [_delegate getDataFromDelegateFunc:i toType:@"future"];
                    return;
                }
            }
        }
    }
    
    for (NSInteger i=0, j= self.oldMeetingList.count; i<j; i++) {
        NSArray *agendaList = [self.oldMeetingList[i] objectForKey:@"agenda"];
        if (agendaList.count != 0) {
            for (NSDictionary *agenda in agendaList) {
                if ([_id isEqualToString:[agenda objectForKey:@"id"]]) {
                    [_delegate getDataFromDelegateFunc:i toType:@"old"];
                }
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *agenda;
    if (_isSearchControllerActive) {
        NSDictionary *dic = self.filterArray[indexPath.row];
        [self getMeetingID:[dic objectForKey:@"id"]];
        agenda = self.filterArray[indexPath.row];
    } else {
        agenda = self.agendaList[indexPath.row];
    }
    
    if ([agenda objectForKey:@"file"]) {
        NSArray *fileList = [agenda objectForKey:@"file"];
        NSDictionary *fileObject = fileList[0];
        pdfFilePath=[[fileObject objectForKey:@"file_path"] lastPathComponent];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:pdfFilePath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [self openPlugPDF];
        } else {
            [self presentViewController:[self showAlertForPdfDownload:[fileObject objectForKey:@"file_name"] path:[fileObject objectForKey:@"file_path"] andPopUpText:@"Do you want to download this pdf file ?"] animated:YES completion:nil];
        }
    }
}

-(void)filterContentForSearchText:(NSString*) searchText {
    [self.filterArray removeAllObjects];
    
    /*NSPredicate *pred = [NSPredicate predicateWithFormat:@"ANY agenda.agenda contains[c] %@", searchText];
     NSArray *result = [_oldMeetingList filteredArrayUsingPredicate:pred];*/
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.agenda contains[c] %@", searchText];
    
    for (NSDictionary *meeting in self.oldMeetingList) {
        if ([meeting objectForKey:@"agenda"]) {
            NSArray *array = [NSMutableArray arrayWithArray:[[meeting objectForKey:@"agenda"] filteredArrayUsingPredicate:predicate]];
            
            for (NSDictionary *item in array) {
                [self.filterArray addObject:item];
            }
        }
    }
    
    for (NSDictionary *meeting in self.futureMeetingList) {
        if ([meeting objectForKey:@"agenda"]) {
            NSArray *array = [NSMutableArray arrayWithArray:[[meeting objectForKey:@"agenda"] filteredArrayUsingPredicate:predicate]];
            
            for (NSDictionary *item in array) {
                [self.filterArray addObject:item];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *trimmedText = [searchController.searchBar.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    if (![trimmedText isEqualToString:@""]) {
        [self filterContentForSearchText:trimmedText];
    }
}

/*-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
 NSLog(@"Cancel Button Clicked");
 [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
 }*/


@end
