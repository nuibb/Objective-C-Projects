//
//  VehicleTracker.m
//  MCP
//
//  Created by Nascenia on 6/26/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "VehicleTracker.h"

@interface VehicleTracker ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation VehicleTracker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *str = @"";
    for (NSInteger i=0, j= _stepsArray.count; i<j; i++) {
        str = [NSString stringWithFormat:@"%@%@%@", str, _stepsArray[i], @"\n\n"];
    }
    
    self.label.text = str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
