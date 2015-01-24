//
//  KTPMembersCell.m
//  KTP
//
//  Created by Owen Yang on 1/24/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPMembersCell.h"
#import "KTPMember.h"

@implementation KTPMembersCell

/*!
 Overridden setter for member property. Calls loadLabel if a new member is set.
 
 @param         member
 */
- (void)setMember:(KTPMember *)member {
    if (_member != member) {
        _member = member;
        [self loadLabel];
    }
}

/*!
 Loads the text label of the cell with the first and last name of the cell's member.
 */
- (void)loadLabel {
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.member.firstName, self.member.lastName];
}

@end
