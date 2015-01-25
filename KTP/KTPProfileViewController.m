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
}

/*!
 Initializes and loads majorLabel, and adds it as a subview
 */
- (void)loadMajorLabel {
    // IMPLEMENT
    // Use "MAJOR" as a default
}

- (void)loadGradLabel {
    // IMPLEMENT
    // Use "0000" as a default
}

- (void)loadHometownLabel {
    // IMPLEMENT
    // Use "EARTH" as a default
}

- (void)loadStatusLabel {
    // IMPLEMENT
    // Use "NONE" as a default
}

- (void)loadRoleLabel {
    // IMPLEMENT
    // Use "NONE" as a default
}

- (void)loadPledgeClassLabel {
    // IMPLEMENT
    // Use "NONE" as a default
}

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

    // Label all views for autolayout
    NSDictionary *views = @{
                            // FORMAT:
                            // @"label"     :   view
                            };
    
    /* profileImageView */
    
    /* majorLabel */
}



@end
