//
//  SectionHeaderView.m
//  DemmoOBJ-C
//
//  Created by Nascenia on 3/18/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

- (void)awakeFromNib {
    
    // set the selected image for the disclosure button
    [self.disclosureBtn setImage:[UIImage imageNamed:@"Close Cart"] forState:UIControlStateNormal];
    [self.disclosureBtn setImage:[UIImage imageNamed:@"Open Cart"] forState:UIControlStateSelected];
    
    // set up the tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
}

- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

-(void)toggleOpenWithUserAction:(BOOL)userAction{
    // toggle the disclosure button state
    self.disclosureBtn.selected = !self.disclosureBtn.selected;
    
    // if this was a user action, send the delegate the appropriate message
    if (userAction) {
        if (self.disclosureBtn.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView: self sectionOpened: self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }

}

@end
