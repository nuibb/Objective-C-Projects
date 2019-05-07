//
//  ShowIPOResult.m
//  bdipo
//
//  Created by Nascenia on 3/11/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "ShowIPOResult.h"

@interface ShowIPOResult ()
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ShowIPOResult

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = 60.00f;
    self.companyName.text = _cName;
    self.desc.text = _descText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_searchResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowIPOResultCustomCell  *cell = [[ShowIPOResultCustomCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ShowIPOResultCustomCell"];
    
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if (indexPath.row % 2) {
        cell.label1.backgroundColor = [UIColor colorWithRed: 232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0];
        cell.label2.backgroundColor = [UIColor colorWithRed: 232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0];
        cell.label3.backgroundColor = [UIColor colorWithRed: 232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0];
        cell.label4.backgroundColor = [UIColor colorWithRed: 232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0];
    }
    
    NSDictionary *result = _searchResult[indexPath.row];
    cell.label1.text = [result[@"lottery_serial"] stringValue];
    cell.label2.text = [result[@"bank_code"] stringValue];
    cell.label3.text = [result[@"branch_code"] stringValue];
    cell.label4.text = result[@"bank_serial"];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShowIPOResultHeaderCell  *view = [[ShowIPOResultHeaderCell alloc] init];
    
    [[view contentView] setFrame:[view bounds]];
    [[view contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
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
