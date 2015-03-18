//
//  KTPMembersCell.m
//  KTP
//
//  Created by Owen Yang on 1/24/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPMembersCell.h"
#import "KTPMember.h"
#import "KTPSMembers.h"
#import "FLAnimatedImage.h"

@interface KTPMembersCell ()

@property (nonatomic, strong) FLAnimatedImageView *profileImageView;
@end

@implementation KTPMembersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.profileImageView = [FLAnimatedImageView new];
        [self.contentView addSubview:self.profileImageView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberUpdated:) name:KTPNotificationMemberUpdated object:self.member];
        [self loadSubviews];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self loadData];
    [self autoLayoutSubviews];
}

/*!
 Loads the imageView, textLabel, and detailTextLabel with the profile image, first/last name, and role of the cell's member, respectively.
 */
- (void)loadData {
    if ([self.member.image isKindOfClass:[UIImage class]]) {
        self.profileImageView.image = self.member.image;
        self.profileImageView.animatedImage = nil;
    } else {
        self.profileImageView.image = nil;
        self.profileImageView.animatedImage = self.member.image;
    }
    
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.member.firstName, self.member.lastName];
    self.detailTextLabel.text = self.member.role;
    
    switch ([KTPSMembers members].sortType) {
        case KTPMembersSortTypeFirstName:
        case KTPMembersSortTypeLastName:
        case KTPMembersSortTypeRole:
            break;
        case KTPMembersSortTypePledgeClass:
            self.detailTextLabel.text = [NSString stringWithFormat:@"(%@) %@", self.member.pledgeClass, self.detailTextLabel.text];
            break;
        case KTPMembersSortTypeStatus:
            self.detailTextLabel.text = [NSString stringWithFormat:@"(%@) %@", self.member.status, self.detailTextLabel.text];
            break;
        case KTPMembersSortTypeGradYear:
            self.detailTextLabel.text = [NSString stringWithFormat:@"(%ld) %@", (long)self.member.gradYear, self.detailTextLabel.text];
            break;
        case KTPMembersSortTypeMajor:
            self.detailTextLabel.text = self.member.major;
            break;
    }
}

#pragma mark - Auto Layout

- (void)autoLayoutSubviews {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"profileImageView" :   self.profileImageView,
                            @"textLabel"        :   self.textLabel,
                            @"detailLabel"      :   self.detailTextLabel
                            };
    
    /* Ensure profileImageView is square */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.profileImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    /* profileImageView and textLabel horizontal space */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[profileImageView]-10-[textLabel]-0-|" options:0 metrics:nil views:views]];
    
    /* profileImageView vertical position */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    /* textLabel and detailTextLabel vertical position */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    /* detailTextLabel horizontal position and space */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailTextLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[detailLabel]-0-|" options:0 metrics:nil views:views]];
}

#pragma mark - Notification Handling

- (void)memberUpdated:(NSNotification*)notification {
    // Workaround -- image does not update right away if this instruction is not
    // dispatched to the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

@end
