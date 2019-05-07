//
//  ShowIPOResultCustomCell.m
//  bdipo
//
//  Created by Nascenia on 3/25/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "ShowIPOResultCustomCell.h"

@implementation ShowIPOResultCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShowIPOResultCustomCell" owner:self options:nil] firstObject];
    }
    
    return self ;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
