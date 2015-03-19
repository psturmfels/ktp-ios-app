//
//  KTPLoginViewController.m
//  KTP
//
//  Created by Greg Azevedo on 8/27/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPLoginViewController.h"
//views
#import "KTPBlockView.h"
#import "KTPTextField.h"
//data
#import "KTPSUser.h"

@interface KTPLoginViewController () <UITextFieldDelegate>

@property (nonatomic) KTPBlockView *ktpBlockView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) KTPTextField *usernameInput;
@property (nonatomic) KTPTextField *passwordInput;
@property (nonatomic) UIButton *logInButton;
@property (nonatomic) UITapGestureRecognizer *animationTap;

@end

@implementation KTPLoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [super loadView];
    [self loadScrollView];
    [self loadLogo];
    [self loadTextFields];
    [self loadLoginButton];
    //    [self setAutoLayoutConstraints];
}

- (void)loadScrollView
{
    self.scrollView = [UIScrollView new];
    self.scrollView.frame = self.view.frame;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = [UIColor KTPDarkGray];
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
}

- (void)loadLogo
{
    self.ktpBlockView = [[KTPBlockView alloc] initWithFrame:CGRectMake(25, 100, self.view.frame.size.width-40, self.view.frame.size.height/2)];
    [self.scrollView addSubview:self.ktpBlockView];
}

- (void)loadTextFields
{
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width-100, 40);
    self.usernameInput = [[KTPTextField alloc] initWithFrame:textRect];
    self.usernameInput.center = CGPointMake(self.scrollView.center.x, 260);
    self.usernameInput.placeholder = @"Username";
    self.usernameInput.keyboardType = UIKeyboardTypeEmailAddress;
    self.usernameInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameInput.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameInput.enablesReturnKeyAutomatically = YES;
    self.usernameInput.delegate = self;
    [self.scrollView addSubview:self.usernameInput];
    
    self.passwordInput = [[KTPTextField alloc] initWithFrame:textRect];
    self.passwordInput.center = CGPointMake(self.scrollView.center.x, 310);
    self.passwordInput.placeholder = @"Password";
    self.passwordInput.delegate = self;
    self.passwordInput.secureTextEntry = YES;
    [self.scrollView addSubview:self.passwordInput];
}

- (void)loadLoginButton
{
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width-100, 50);
    self.logInButton = [UIButton new];
    self.logInButton.frame = textRect;
    self.logInButton.center = CGPointMake(self.scrollView.center.x, 360);
    [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.logInButton setTitleColor:[UIColor KTPOpenGreen] forState:UIControlStateNormal];
    [self.logInButton setTitleColor:[[UIColor KTPOpenGreen] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self.logInButton addTarget:self action:@selector(tappedLogIn) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.logInButton];
}

- (void)setAutoLayoutConstraints
{
    self.usernameInput.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordInput.translatesAutoresizingMaskIntoConstraints = NO;
    self.ktpBlockView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"username": self.usernameInput, @"password":self.passwordInput};
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[logo]-|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[username]-|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[password]-|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[username]-[password]-100-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDownOnView:)];
    [self.scrollView addGestureRecognizer:self.animationTap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Attempt to login with Touch ID
    [[KTPSUser currentUser] loginWithTouchID:^(BOOL successful, NSError *error) {
        if (successful) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if ([error.domain isEqualToString:KTPLoginErrorTouchIDFailed]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                           message:@"Touch ID authentication failed"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.ktpBlockView waveAnimationFromPoint:textField.frame.origin];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.usernameInput]) {
        [self setFocusOnTextField:self.passwordInput];
    } else if ([textField isEqual:self.passwordInput]) {
        [self removeFocusFromTextField:self.passwordInput];
    }
    return YES;
}

- (void)removeFocusFromTextField:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)setFocusOnTextField:(UITextField *)textField
{
    [textField becomeFirstResponder];
    //    [self.scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
}

#pragma mark - UI action selectors

- (void)touchDownOnView:(UITapGestureRecognizer *)tap
{
    if ([self.usernameInput isFirstResponder]) {
        [self removeFocusFromTextField:self.usernameInput];
    } else if ([self.passwordInput isFirstResponder]) {
        [self removeFocusFromTextField:self.passwordInput];
    } else {
        CGPoint location = [tap locationInView:self.scrollView];
        [self.ktpBlockView waveAnimationFromPoint:location];
    }
}

- (void)tappedLogIn
{
    [self.view endEditing:YES];
    [[KTPSUser currentUser] loginWithUsername:self.usernameInput.text password:self.passwordInput.text block:^(BOOL successful, NSError *error) {
        if (successful) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                           message:@"Invalid login information"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

@end
