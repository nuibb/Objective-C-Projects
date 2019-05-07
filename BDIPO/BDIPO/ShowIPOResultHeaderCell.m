//
//  ShowIPOResultHeaderCell.m
//  bdipo
//
//  Created by Nascenia on 3/11/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "ShowIPOResultHeaderCell.h"

@implementation ShowIPOResultHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShowIPOResultHeaderCell" owner:self options:nil] firstObject];
    }
    
    return self ;
}

- (void)awakeFromNib {
    // Initialization code
    self.label1.text = @"Lotery\nSerial";
    self.label2.text = @"Bank \n Code";
    self.label3.text = @"Branch\nCode";
    self.label4.text = @"Bank\nSerial";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
