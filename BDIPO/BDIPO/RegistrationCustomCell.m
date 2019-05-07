//
//  RegistrationCustomCell.m
//  bdipo
//
//  Created by Nascenia on 4/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RegistrationCustomCell.h"

@implementation RegistrationCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RegistrationCustomCell" owner:self options:nil] firstObject];
    }
    
    return self;
}

/*- (IBAction)registerBtnEventListener:(id)sender {
    [self.delegate goToPaymentSelection:1];
}*/

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
