//
//  KTPProfileViewController.m
//  KTP
//
//  Created by Owen Yang on 1/24/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>

#import "KTPProfileViewController.h"
#import "KTPMember.h"
#import "KTPSUser.h"
#import "KTPEditProfileViewController.h"
#import "KTPProfileFratInfoView.h"
#import "KTPProfilePersonalInfoView.h"
#import "KTPProfileNameView.h"
#import "KTPProfileBioView.h"
#import "KTPProfileButtonsView.h"

#import "KTPNetworking.h"

@interface KTPProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) KTPProfileFratInfoView *fratInfo;
@property (nonatomic, strong) KTPProfilePersonalInfoView *personalInfo;
@property (nonatomic, strong) KTPProfileNameView *nameView;
@property (nonatomic, strong) KTPProfileBioView *bioView;
@property (nonatomic, strong) KTPProfileButtonsView *buttonsView;


@end

@implementation KTPProfileViewController

#pragma mark - Initialization

- (instancetype)initWithMember:(KTPMember*)member {
    self = [super init];
    if (self) {
        self.member = member;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Overriden Setters/Getters

/*!
 Overriden setter for member property. Sets the title of this VC to the first and last name of the member.
 
 @param         member
 */
- (void)setMember:(KTPMember *)member {
    if (_member != member) {
        _member = member;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberUpdated:) name:KTPNotificationMemberUpdated object:self.member];
        [self loadContent];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([KTPSUser currentMember] == self.member || [KTPSUser currentUserIsAdmin]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                               target:self
                                                                                               action:@selector(editButtonTapped)];
    }
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadContent];
}

- (void)loadContent {
    
    self.navigationItem.title = self.member.firstName;
    
    self.nameView.nameLabel.text = [NSString stringWithFormat:@"%@\n%@", self.member.firstName, self.member.lastName];
    self.nameView.profileImageView.image = self.member.image;
    
    self.bioView.textLabel.text = self.member.biography;
    
    self.fratInfo.statusLabel.text = [NSString stringWithFormat:@"Status: %@", self.member.status];
    self.fratInfo.roleLabel.text = [NSString stringWithFormat:@"Role: %@", self.member.role];
    self.fratInfo.pledgeClassLabel.text = [NSString stringWithFormat:@"Pledge Class: %@", self.member.pledgeClass];
    
    self.personalInfo.majorLabel.text = [NSString stringWithFormat:@"Major: %@", self.member.major];
    self.personalInfo.gradLabel.text = [NSString stringWithFormat:@"Graduation Year: %ld", (long)self.member.gradYear];
    self.personalInfo.hometownLabel.text = [NSString stringWithFormat:@"Hometown: %@", self.member.hometown];
    
    if ((self.buttonsView.phoneButton.enabled = [self.member.phoneNumber isNotNilOrEmpty])) {
        [self.buttonsView.phoneButton setImage:[UIImage imageNamed:@"PhoneIcon"] forState:UIControlStateNormal];
        [self.buttonsView.phoneButton setImage:[UIImage imageNamed:@"PhoneIconHighlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.buttonsView.phoneButton setImage:[UIImage imageNamed:@"PhoneIconHighlighted"] forState:UIControlStateNormal];
    }
    
    if ((self.buttonsView.emailButton.enabled = [self.member.email isNotNilOrEmpty])) {
        [self.buttonsView.emailButton setImage:[UIImage imageNamed:@"EmailIcon"] forState:UIControlStateNormal];
        [self.buttonsView.emailButton setImage:[UIImage imageNamed:@"EmailIconHighlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.buttonsView.emailButton setImage:[UIImage imageNamed:@"EmailIconHighlighted"] forState:UIControlStateNormal];
    }
    
    if ((self.buttonsView.facebookButton.enabled = [self.member.facebook isNotNilOrEmpty])) {
        [self.buttonsView.facebookButton setImage:[UIImage imageNamed:@"FacebookLogo"] forState:UIControlStateNormal];
        [self.buttonsView.facebookButton setImage:[UIImage imageNamed:@"FacebookLogoHighlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.buttonsView.facebookButton setImage:[UIImage imageNamed:@"FacebookLogoHighlighted"] forState:UIControlStateNormal];
    }
    
    if ((self.buttonsView.twitterButton.enabled = [self.member.twitter isNotNilOrEmpty])) {
        [self.buttonsView.twitterButton setImage:[UIImage imageNamed:@"TwitterWhiteLogo"] forState:UIControlStateNormal];
        [self.buttonsView.twitterButton setImage:[UIImage imageNamed:@"TwitterWhiteLogoHighlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.buttonsView.twitterButton setImage:[UIImage imageNamed:@"TwitterWhiteLogoHighlighted"] forState:UIControlStateNormal];
    }
    
    if ((self.buttonsView.linkedInButton.enabled = [self.member.linkedIn isNotNilOrEmpty])) {
        [self.buttonsView.linkedInButton setImage:[UIImage imageNamed:@"LinkedInLogo"] forState:UIControlStateNormal];
        [self.buttonsView.linkedInButton setImage:[UIImage imageNamed:@"LinkedInLogoHighlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.buttonsView.linkedInButton setImage:[UIImage imageNamed:@"LinkedInLogoHighlighted"] forState:UIControlStateNormal];
    }
    
    if ((self.buttonsView.personalSiteButton.enabled = [self.member.personalSite isNotNilOrEmpty])) {
        [self.buttonsView.personalSiteButton setImage:[UIImage imageNamed:@"PersonalSiteIcon"] forState:UIControlStateNormal];
        [self.buttonsView.personalSiteButton setImage:[UIImage imageNamed:@"PersonalSiteIconHighlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.buttonsView.personalSiteButton setImage:[UIImage imageNamed:@"PersonalSiteIconHighlighted"] forState:UIControlStateNormal];
    }
}

#pragma mark - Loading Subviews

/*!
 Loads all subviews of self.scrollView
 */
- (void)loadSubviews {
    // Container views
    [self loadScrollView];
    [self loadContentView];
    [self loadSectionViews];
}

- (void)loadScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.backgroundColor = [UIColor KTPDarkGray];
    [self.view addSubview:self.scrollView];
}

- (void)loadContentView {
    CGRect frame = self.scrollView.bounds;
    frame.size.height = 1000;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.scrollView addSubview:self.contentView];
}

- (void)loadSectionViews {
    
    self.nameView = [KTPProfileNameView new];
    if ([KTPSUser currentMember] == self.member || [KTPSUser currentUserIsAdmin]) {
        [self.nameView.profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTapped)]];
    }
    [self.contentView addSubview:self.nameView];
    
    self.bioView = [KTPProfileBioView new];
    [self.contentView addSubview:self.bioView];
    
    self.fratInfo = [KTPProfileFratInfoView new];
    [self.contentView addSubview:self.fratInfo];
    
    self.personalInfo = [KTPProfilePersonalInfoView new];
    [self.contentView addSubview:self.personalInfo];
    
    self.buttonsView = [KTPProfileButtonsView new];
    [self.buttonsView.phoneButton addTarget:self action:@selector(phoneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.phoneButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(phoneButtonLongPressed)]];
    [self.buttonsView.emailButton addTarget:self action:@selector(emailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.emailButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(emailButtonLongPressed)]];
    [self.buttonsView.facebookButton addTarget:self action:@selector(facebookButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.facebookButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(facebookButtonLongPressed)]];
    [self.buttonsView.twitterButton addTarget:self action:@selector(twitterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.twitterButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(twitterButtonLongPressed)]];
    [self.buttonsView.linkedInButton addTarget:self action:@selector(linkedInButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.linkedInButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkedInButtonLongPressed)]];
    [self.buttonsView.personalSiteButton addTarget:self action:@selector(personalSiteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.personalSiteButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(personalSiteButtonLongPressed)]];
    [self.contentView addSubview:self.buttonsView];
    
}

- (void)autoLayoutSubviews {
    
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"nameView"     :   self.nameView,
                            @"bioView"      :   self.bioView,
                            @"fratInfo"     :   self.fratInfo,
                            @"personalInfo" :   self.personalInfo,
                            @"buttonsView"  :   self.buttonsView
                            };
    
    /* nameView */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[nameView]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[nameView]" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.view.frame.size.width * 0.4]];
    
    /* bioView */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[bioView]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameView]-10-[bioView]" options:0 metrics:nil views:views]];
    
    /* fratInfo */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bioView]-20-[fratInfo]-20-[personalInfo]-20-[buttonsView]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fratInfo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bioView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    /* personalInfo */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.personalInfo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.fratInfo attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    /* buttonsView */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonsView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.personalInfo attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Get the top and bottom subviews of contentView
    UIView *topView, *bottomView;
    for (UIView *view in self.contentView.subviews) {
        if (!topView || topView.frame.origin.y > view.frame.origin.y) {
            topView = view;
        }
        if (!bottomView || bottomView.frame.origin.y + bottomView.frame.size.height < view.frame.origin.y + view.frame.size.height) {
            bottomView = view;
        }
    }
    
    // Resize contentView such that it is larger than its subviews
    CGRect frame = self.contentView.frame;
    frame.size.height = topView.frame.origin.y + bottomView.frame.origin.y + bottomView.frame.size.height + kContentViewBottomPadding;
    self.contentView.frame = frame;
    
    // Set the content size of scrollView to contentView's size
    self.scrollView.contentSize = self.contentView.frame.size;
}
     

#pragma mark - UI action selectors

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
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    self.nameView.profileImageView.image = image;
    self.member.image = image;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePOST toRoute:KTPRequestRouteAPIMembers appending:[NSString stringWithFormat:@"%@/upload_pic", self.member._id] parameters:nil withData:imageData contentType:KTPContentTypePNG block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error || [(NSHTTPURLResponse*)response statusCode] >= 300) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Upload Failed" message:@"Your image could not be saved" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editButtonTapped {
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[KTPEditProfileViewController alloc] initWithMember:self.member]];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)phoneButtonTapped {
    NSString *phoneNumber = [[self.member.phoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789-=()"].invertedSet] componentsJoinedByString:@""];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Send Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageVC = [MFMessageComposeViewController new];
            messageVC.messageComposeDelegate = self;
            messageVC.recipients = @[phoneNumber];
            [self presentViewController:messageVC animated:YES completion:nil];
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)phoneButtonLongPressed {
    [self showCopyAlertControllerWithTitle:@"Copy Phone Number" copiedValue:self.member.phoneNumber];
}

- (void)emailButtonTapped {
    MFMailComposeViewController *mailComposeVC = [MFMailComposeViewController new];
    mailComposeVC.mailComposeDelegate = self;
    [mailComposeVC setToRecipients:@[self.member.email]];
    [self presentViewController:mailComposeVC animated:YES completion:nil];
}

- (void)emailButtonLongPressed {
    [self showCopyAlertControllerWithTitle:@"Copy Email" copiedValue:self.member.email];
}

- (void)twitterButtonTapped {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", self.member.twitter]]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", self.member.twitter]]];
    }
}

- (void)twitterButtonLongPressed {
    [self showCopyAlertControllerWithTitle:@"Copy Twitter Handle" copiedValue:self.member.twitter];
}

- (void)facebookButtonTapped {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        // make request to facebook graph api to get user's id from username, then use id to launch facebook app to correct profile
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@", self.member.facebook]]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", res[@"id"]]]];
            } else {
                NSLog(@"There was an error making the facebook request");
            }
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@", self.member.facebook]]];
    }
}

- (void)facebookButtonLongPressed {
    [self showCopyAlertControllerWithTitle:@"Copy Facebook Username" copiedValue:self.member.facebook];
}

- (void)linkedInButtonTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://linkedin.com/in/%@", self.member.linkedIn]]];
}

- (void)linkedInButtonLongPressed {
    [self showCopyAlertControllerWithTitle:@"Copy LinkedIn Username" copiedValue:self.member.linkedIn];
}

- (void)personalSiteButtonTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.member.personalSite]]];
}

- (void)personalSiteButtonLongPressed {
    [self showCopyAlertControllerWithTitle:@"Copy Link" copiedValue:self.member.personalSite];
}

- (void)showCopyAlertControllerWithTitle:(NSString*)title copiedValue:(NSString*)value {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [UIPasteboard generalPasteboard].string = value;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification Handling

- (void)memberUpdated:(NSNotification*)notification {
    // Workaround -- image does not update right away if this instruction is not
    // dispatched to the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadContent];
    });
}

@end
