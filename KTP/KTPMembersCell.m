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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

/*!
 Overridden setter for member property. Calls loadSubviews if a new member is set.
 
 @param         member
 */
- (void)setMember:(KTPMember *)member {
    if (_member != member) {
        _member = member;
        [self loadSubviews];
    }
}

#pragma mark - Load Views

- (void)loadSubviews {
    [self loadImage];
    [self loadLabel];
    [self loadDetailLabel];
    [self autoLayoutSubviews];
}

/*!
 Loads the image view of the cell with the profile image of the cell's member.
 */
- (void)loadImage {
    self.imageView.image = self.member.image;
}

/*!
 Loads the text label of the cell with the first and last name of the cell's member.
 */
- (void)loadLabel {
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.member.firstName, self.member.lastName];
}

/*!
 Loads the detail text label of the cell with the role of the cell's member.
 */
- (void)loadDetailLabel {
    self.detailTextLabel.text = self.member.role;
}

#pragma mark - Auto Layout

- (void)autoLayoutSubviews {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"imageView"    :   self.imageView,
                            @"textLabel"    :   self.textLabel,
                            @"detailLabel"  :   self.detailTextLabel
                            };
    
    /* Ensure imageView is square */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    /* imageView and textLabel horizontal space */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[imageView]-10-[textLabel]-0-|" options:0 metrics:nil views:views]];
    
    /* imageView vertical position */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    /* textLabel and detailTextLabel vertical position */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    /* detailTextLabel horizontal position and space */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailTextLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[detailLabel]-0-|" options:0 metrics:nil views:views]];
    
}

@end
