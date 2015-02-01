//
//  KTPProfileViewController.m
//  KTP
//
//  Created by Owen Yang on 1/24/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "KTPProfileViewController.h"
#import "KTPMember.h"
#import "KTPSUser.h"

@interface KTPProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
@property (nonatomic, strong) UILabel *statusDataLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UILabel *roleDataLabel;
@property (nonatomic, strong) UILabel *pledgeClassLabel;
@property (nonatomic, strong) UILabel *pledgeClassDataLabel;
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
    // Container views
    [self loadScrollView];
    [self loadContentView];
    
    // Content views
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

#define PROFILE_IMAGE_RADIUS 10

/*!
 Initializes and loads an image into profileImageView, and adds as subviews
 */
- (void)loadProfileImageView {
    self.profileImageView = [[UIImageView alloc] initWithImage:self.member.image];
    self.profileImageView.layer.cornerRadius = PROFILE_IMAGE_RADIUS;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.userInteractionEnabled = YES;
    [self.profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTapped)]];
    [self.contentView addSubview:self.profileImageView];
}

/*!
 Initializes and loads majorLabel and majorDataLabel, and adds as subviews
 */
- (void)loadMajorLabel {
    self.majorLabel = [UILabel new];
    self.majorLabel.text = @"Major:";
    [self.contentView addSubview:self.majorLabel];
    
    self.majorDataLabel = [UILabel new];
    self.majorDataLabel.text = self.member.major;
    self.majorDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.majorDataLabel];
}

/*!
 Initializes and loads gradLabel and gradDataLabel, and adds as subviews
 */
- (void)loadGradLabel {
    // Use "0000" as a default
    self.gradLabel = [UILabel new];
    self.gradLabel.text = @"Grad Year:";
    [self.contentView addSubview:self.gradLabel];
    
    self.gradDataLabel = [UILabel new];
    self.gradDataLabel.text = [NSString stringWithFormat:@"%ld",(long)self.member.gradYear];
    if (self.member.gradYear == 0) {
        self.gradDataLabel.text = @"0000";
    }
    [self.contentView addSubview:self.gradDataLabel];
}

/*!
 Initializes and loads hometownLabel and hometownDataLabel, and adds as subviews
 */
- (void)loadHometownLabel {
    self.hometownLabel = [UILabel new];
    self.hometownLabel.text = @"Hometown:";
    [self.contentView addSubview:self.hometownLabel];
    
    self.hometownDataLabel = [UILabel new];
    self.hometownDataLabel.text = self.member.hometown;
    self.hometownDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.hometownDataLabel];
}

/*!
 Initializes and loads statusLabel and statusDataLabel, and adds as subviews
 */
- (void)loadStatusLabel {
    self.statusLabel = [UILabel new];
    self.statusLabel.text = @"Status:";
    [self.contentView addSubview:self.statusLabel];
    
    self.statusDataLabel = [UILabel new];
    self.statusDataLabel.text = self.member.status;
    [self.contentView addSubview:self.statusDataLabel];
}

/*!
 Initializes and loads roleLabel and roleDataLabel, and adds as subviews
 */
- (void)loadRoleLabel {
    self.roleLabel = [UILabel new];
    self.roleLabel.text = @"Role:";
    [self.contentView addSubview:self.roleLabel];
    
    self.roleDataLabel = [UILabel new];
    self.roleDataLabel.text = self.member.role;
    [self.contentView addSubview:self.roleDataLabel];
}

/*!
 Initializes and loads pledgeClassLabel and pledgeClassDataLabel, and adds as subviews
 */
- (void)loadPledgeClassLabel {
    self.pledgeClassLabel = [UILabel new];
    self.pledgeClassLabel.text = @"Pledge Class:";
    [self.contentView addSubview:self.pledgeClassLabel];
    
    self.pledgeClassDataLabel = [UILabel new];
    self.pledgeClassDataLabel.text = self.member.pledgeClass;
    [self.contentView addSubview:self.pledgeClassDataLabel];
}

/*!
 Initializes and loads bioTextView, and adds it as a subview
 */
- (void)loadBioTextView {
    // IMPLEMENT
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
                            @"hometownDataLabel"    :   self.hometownDataLabel,
                            @"statusLabel"          :   self.statusLabel,
                            @"statusDataLabel"      :   self.statusDataLabel,
                            @"roleLabel"            :   self.roleLabel,
                            @"roleDataLabel"        :   self.roleDataLabel,
                            @"pledgeClassLabel"     :   self.pledgeClassLabel,
                            @"pledgeClassDataLabel" :   self.pledgeClassDataLabel
                            };
    
    /* profileImageView */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.profileImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[profileImageView]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[profileImageView]" options:0 metrics:nil views:views]];
    
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
    
    /* major, grad, hometown label/data vertical spacing */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[majorDataLabel]-5-[gradLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradDataLabel]-5-[hometownLabel]" options:0 metrics:nil views:views]];
    
    /* pledgeClass, role, status labels positions */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pledgeClassLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.profileImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pledgeClassLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.hometownDataLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pledgeClassLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.profileImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pledgeClassLabel]-5-[roleLabel]-5-[statusLabel]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    /* pledgeClass, role, status label/data vertical alignment */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pledgeClassLabel]-10-[pledgeClassDataLabel]" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.roleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.roleDataLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.statusDataLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    /* pledgeClass, role, status data left alignment */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pledgeClassDataLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.roleDataLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.roleDataLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.statusDataLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
}

- (void)showEditView {
//    [self.member update:nil];
}

/*!
 Method called when the profile image is tapped. Displays an actionsheet that allows the user to choose a photo from the library or take a new one.
 */
- (void)profileImageTapped {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.mediaTypes = @[(NSString*)kUTTypeImage]; // only allow images
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = image;
    self.member.image = image;
    [self.member update:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
