//
//  KTPProfileViewController.m
//  KTP
//
//  Created by Owen Yang on 1/24/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileViewController.h"
#import "KTPMember.h"

@interface KTPProfileViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

// Public Member Info
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *majorLabel;
@property (nonatomic, strong) UILabel *gradLabel;
@property (nonatomic, strong) UILabel *hometownLabel;
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}

/*!
 Loads all subviews of self.scrollView
 */
- (void)loadSubviews {
    [self loadProfileImageView];
    [self loadMajorLabel];
    [self loadGradLabel];
    [self loadHometownLabel];
    [self loadStatusLabel];
    [self loadRoleLabel];
    [self loadPledgeClassLabel];
    [self loadBioTextView];
}

/*!
 Initializes and loads an image into profileImageView, and adds it as a subview
 */
- (void)loadProfileImageView {
    // IMPLEMENT
    // Use the image named UserPlaceholder as a default
    self.profileImageView = [UIImageView new];
    self.profileImageView.image = [UIImage imageNamed:@"UserPlaceholder"];
    [self.scrollView addSubview:self.profileImageView];
}

/*!
 Initializes and loads majorLabel, and adds it as a subview
 */
- (void)loadMajorLabel {
    // IMPLEMENT
    // Use "MAJOR" as a default
    if([self.member.major isEqualToString:@""]) {
        self.majorLabel.text = @"Major: MAJOR";
    }
    self.majorLabel = [UILabel new];
    self.majorLabel.text = [NSString stringWithFormat:@"Major: %@", self.member.major];
    [self.scrollView addSubview:self.majorLabel];
    
}

/*!
 Initializes and loads gradLabel, and adds it as a subview
 */
- (void)loadGradLabel {
    // IMPLEMENT
    // Use "0000" as a default
}

/*!
 Initializes and loads hometownLabel, and adds it as a subview
 */
- (void)loadHometownLabel {
    // IMPLEMENT
    // Use "EARTH" as a default
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
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.majorLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // Label all views for autolayout
    NSDictionary *views = @{
                            @"profileImageView" :   self.profileImageView,
                            @"majorLabel"       :   self.majorLabel
                            // FORMAT:
                            // @"label"     :   view
                            };
    
    /* profileImageView */
    NSArray *profileImageViewHorizPos = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[profileImageView]" options:0 metrics:nil views:views];
    NSArray *profileImageViewVertPos = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[profileImageView]" options:0 metrics:nil views:views];
    NSArray *profileImageViewHorizSize = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileImageView(150)]" options:0 metrics:nil views:views];
    NSArray *profileImageViewVertSize = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[profileImageView(150)]" options:0 metrics:nil views:views];
    [self.scrollView addConstraints:profileImageViewHorizPos];
    [self.scrollView addConstraints:profileImageViewVertPos];
    [self.scrollView addConstraints:profileImageViewHorizSize];
    [self.scrollView addConstraints:profileImageViewVertSize];
    
    /* majorLabel */
    NSArray *majorLabelHorizPos = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileImageView]-20-[majorLabel]" options:0 metrics:nil views:views];
    NSArray *majorLabelVertPos = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[majorLabel]" options:0 metrics:nil views:views];
    [self.scrollView addConstraints:majorLabelHorizPos];
    [self.scrollView addConstraints:majorLabelVertPos];
    
}



@end
