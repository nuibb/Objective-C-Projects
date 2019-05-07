//
//  SecondViewController.m
//  bdipo
//
//  Created by Nascenia on 2/24/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "SecondViewController.h"
#import "GetServices.h"
#import "Settings.h"
#import "NewsShow.h"
#import "News.h"

@interface SecondViewController ()
@property GetServices *getService;
@property Settings *settings;
@property NSMutableArray *newsList;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Get news from server and reload the table view
    self.newsList = [[NSMutableArray alloc] init];
    self.settings = [[Settings alloc]init];
    self.getService = [[GetServices alloc]init];
    [self.getService apiCallToGet:[self.settings getAllNews] callback:^(NSDictionary *response){
        for (NSDictionary *news in response) {
            if ([news objectForKey:@"title"] && [news objectForKey:@"url"]) {
                News *hotNews = [[News alloc] initWithObjects: [news objectForKey:@"id"] toTitle:[news objectForKey:@"title"] toUrl:[news objectForKey:@"url"]];
                [self.newsList addObject:hotNews];
            }
        }
        
        // Update the UI on the main thread.
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.newsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    News *news = self.newsList[indexPath.row];
    cell.textLabel.text = news.title;
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewsShow *vc = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    vc.cName = cell.textLabel.text;
    vc.url = [(News *)self.newsList[indexPath.row] url];
}

@end
