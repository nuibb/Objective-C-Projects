//
//  ShareInfoCell.m
//  Meeting Mate
//
//  Created by nuibb on 8/7/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import "ShareInfoCell.h"

@implementation ShareInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)cancelBtnClickListener:(id)sender {
    [self.delegate cancelSharingMeetingInfo];
}

- (IBAction)shareBtnClickListener:(id)sender {
    [self.delegate shareMeetingInfoToParticipants];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
