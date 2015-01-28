//
//  KTPProfileViewController.m
//  KTP
//
//  Created by Owen Yang on 1/24/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileViewController.h"
#import "KTPMember.h"
#import "KTPSUser.h"

@interface KTPProfileViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// Public Member Info
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *majorLabel;
@property (nonatomic, strong) UILabel *majorDataLabel;
@property (nonatomic, strong) UILabel *gradLabel;
@property (nonatomic, strong) UILabel *gradDataLabel;
@property (nonatomic, strong) UILabel *hometownLabel;
@property (nonatomic, strong) UILabel *hometownDataLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UILabel *pledgeClassLabel;
@property (nonatomic, strong) UITextView *bioTextView;

// Private Member Info
@property (nonatomic, strong) UILabel *comServLabel;
@property (nonatomic, strong) UILabel *proDevLabel;
@property (nonatomic, strong) UILabel *attendanceLabel;
@property (nonatomic, strong) UILabel *testScoreLabel;

@end

@implementation KTPProfileViewController

- (instancetype)initWithMember:(KTPMember*)member {
    self = [super init];
    if (self) {
        self.member = member;
    }
    return self;
}

/*!
 Overriden setter for member property. Sets the title of this VC to the first and last name of the member.
 
 @param         member
 */
- (void)setMember:(KTPMember *)member {
    if (_member != member) {
        _member = member;
        self.title = [NSString stringWithFormat:@"%@ %@", member.firstName, member.lastName];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([KTPSUser currentUser].member == self.member) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                               target:self
                                                                                               action:@selector(showEditView)];
    }
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}

/*!
 Loads all subviews of self.scrollView
 */
- (void)loadSubviews {
    [self loadScrollView];
    [self loadContentView];
    [self loadProfileImageView];
    [self loadMajorLabel];
    [self loadGradLabel];
    [self loadHometownLabel];
    [self loadStatusLabel];
    [self loadRoleLabel];
    [self loadPledgeClassLabel];
    [self loadBioTextView];
}

- (void)loadScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
}

- (void)loadContentView {
    self.contentView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.scrollView addSubview:self.contentView];
}

/*!
 Initializes and loads an image into profileImageView, and adds it as a subview
 */
- (void)loadProfileImageView {
    // Use the image named UserPlaceholder as a default
    self.profileImageView = [UIImageView new];
    self.profileImageView.image = [UIImage imageNamed:@"UserPlaceholder"];
    [self.contentView addSubview:self.profileImageView];
}

/*!
 Initializes and loads majorLabel and majorDataLabel, and adds it as a subview
 */
- (void)loadMajorLabel {
    // Use "MAJOR" as a default
    self.majorLabel = [UILabel new];
    self.majorLabel.text = @"Major:";
    [self.contentView addSubview:self.majorLabel];
    
    self.majorDataLabel = [UILabel new];
    self.majorDataLabel.text = @"MAJOR";
    if (self.member.major) {
        self.majorDataLabel.text = self.member.major;
    }
    self.majorDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.majorDataLabel];
}

/*!
 Initializes and loads gradLabel and gradDataLabel, and adds it as a subview
 */
- (void)loadGradLabel {
    // IMPLEMENT
    // Use "0000" as a default
    self.gradLabel = [UILabel new];
    self.gradLabel.text = @"Grad Year:";
    [self.contentView addSubview:self.gradLabel];
    
    self.gradDataLabel = [UILabel new];
    self.gradDataLabel.text = @"0000";
    if (self.member.gradYear) {
        self.gradDataLabel.text = [NSString stringWithFormat:@"%ld",(long)self.member.gradYear];
    }
    [self.contentView addSubview:self.gradDataLabel];
}

/*!
 Initializes and loads hometownLabel and hometownDataLabel, and adds it as a subview
 */
- (void)loadHometownLabel {
    // Use "HOMETOWN" as a default
    self.hometownLabel = [UILabel new];
    self.hometownLabel.text = @"Hometown:";
    [self.contentView addSubview:self.hometownLabel];
    
    self.hometownDataLabel = [UILabel new];
    self.hometownDataLabel.text = @"HOMETOWN";
    if (self.member.hometown) {
        self.hometownDataLabel.text = self.member.hometown;
    }
    [self.contentView addSubview:self.hometownDataLabel];
}

/*!
 Initializes and loads statusLabel, and adds it as a subview
 */
- (void)loadStatusLabel {
    // IMPLEMENT
    // Use "NONE" as a default
}

/*!
 Initializes and loads roleLabel, and adds it as a subview
 */
- (void)loadRoleLabel {
    // IMPLEMENT
    // Use "NONE" as a default
}

/*!
 Initializes and loads pledgeClassLabel, and adds it as a subview
 */
- (void)loadPledgeClassLabel {
    // IMPLEMENT
    // Use "NONE" as a default
}

/*!
 Initializes and loads bioTextView, and adds it as a subview
 */
- (void)loadBioTextView {
    // IMPLEMENT
    // Use "BIO" as a default
}

/*!
 Sets autolayout constraints on subviews of self.scrollView
 */
- (void)autoLayoutSubviews {
    // IMPLEMENT
    
    // Set translatesAutoresizingMaskIntoConstraints property to NO for all autolayout views
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    // Label all views for autolayout
    NSDictionary *views = @{
                            @"profileImageView"     :   self.profileImageView,
                            @"majorLabel"           :   self.majorLabel,
                            @"majorDataLabel"       :   self.majorDataLabel,
                            @"gradLabel"            :   self.gradLabel,
                            @"gradDataLabel"        :   self.gradDataLabel,
                            @"hometownLabel"        :   self.hometownLabel,
                            @"hometownDataLabel"    :   self.hometownDataLabel
                            };
    
    /* profileImageView */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[profileImageView(120)]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[profileImageView(120)]" options:0 metrics:nil views:views]];
    
    /* majorLabel, gradLabel, hometownLabel left alignment */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileImageView]-20-[majorLabel]" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.majorLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.gradLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.gradLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hometownLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    /* label and data top alignment */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.majorLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.majorDataLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.gradLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.gradDataLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.hometownLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hometownDataLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    /* majorDataLabel, gradDataLabel, hometownDataLabel left alignment */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.majorDataLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.gradDataLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.gradDataLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hometownDataLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[hometownLabel(90)]-5-[hometownDataLabel]" options:0 metrics:nil views:views]];
    
    /* majorDataLabel, gradDataLabel, hometownDataLabel right space from containerView */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.majorDataLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.gradDataLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.hometownDataLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    
    /* vertical spacing */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[majorDataLabel]-5-[gradLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradDataLabel]-5-[hometownLabel]" options:0 metrics:nil views:views]];

}

- (void)showEditView {
    
}



@end
