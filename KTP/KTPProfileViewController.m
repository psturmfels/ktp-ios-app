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

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *profileImageView;

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
    
    [self loadSubviews];
}

- (void)loadSubviews {
    [self setupNameLabel];
    [self setupProfileImageView];
}

/*!
 Initializes and loads a name into nameLabel
 */
- (void)setupNameLabel {
    // IMPLEMENT
    
    [self.view addSubview:self.nameLabel];
}

/*!
 Initializes and loads an image into profileImageView
 */
- (void)setupProfileImageView {
    // IMPLEMENT
    
    [self.view addSubview:self.profileImageView];
}



@end
