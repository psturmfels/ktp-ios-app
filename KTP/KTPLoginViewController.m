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
#import "KTPUser.h"

@interface KTPLoginViewController () <UITextFieldDelegate>

@property (nonatomic) KTPBlockView *ktpBlockView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) KTPTextField *usernameInput;
@property (nonatomic) KTPTextField *passwordInput;
@property (nonatomic) UIButton *logInButton;
@property (nonatomic) UITapGestureRecognizer *animationTap;

@end

@implementation KTPLoginViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)loadView
{
    [super loadView];
    [self loadScrollView];
    [self loadLogo];
    [self loadTextFields];
    [self loadLoginButton];
    //    [self setAutoLayoutConstraints];
}

-(void)loadScrollView
{
    self.scrollView = [UIScrollView new];
    [self.scrollView setFrame:self.view.frame];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setBackgroundColor:[UIColor KTPDarkGray]];
    [self.view addSubview:self.scrollView];
}

-(void)loadLogo
{
    self.ktpBlockView = [[KTPBlockView alloc] initWithFrame:CGRectMake(25, 100, self.view.frame.size.width-40, self.view.frame.size.height/2)];
    [self.scrollView addSubview:self.ktpBlockView];
}

-(void)loadTextFields
{
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width-100, 40);
    self.usernameInput = [[KTPTextField alloc] initWithFrame:textRect];
    [self.usernameInput setCenter:CGPointMake(self.scrollView.center.x, 250)];
    [self.usernameInput setPlaceholder:@"Username"];
    [self.usernameInput setDelegate:self];
    [self.scrollView addSubview:self.usernameInput];
    
    self.passwordInput = [[KTPTextField alloc] initWithFrame:textRect];
    [self.passwordInput setCenter:CGPointMake(self.scrollView.center.x, 300)];
    [self.passwordInput setPlaceholder:@"Password"];
    [self.passwordInput setDelegate:self];
    [self.scrollView addSubview:self.passwordInput];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    [left setTitle:@"meh" forState:UIControlStateNormal];
    [self.passwordInput setLeftView:left];
    [self.passwordInput setLeftViewMode:UITextFieldViewModeAlways];
}

-(void)loadLoginButton
{
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width-100, 50);
    self.logInButton = [UIButton new];
    [self.logInButton setFrame:textRect];
    [self.logInButton setCenter:CGPointMake(self.scrollView.center.x, 350)];
    [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.logInButton setTitleColor:[UIColor KTPOpenGreen] forState:UIControlStateNormal];
    [self.logInButton addTarget:self action:@selector(tappedLogIn) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.logInButton];
}

-(void)setAutoLayoutConstraints
{
    [self.usernameInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.passwordInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.ktpBlockView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{@"username": self.usernameInput, @"password":self.passwordInput};
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[logo]-|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[username]-|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[password]-|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[username]-[password]-100-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDownOnView:)];
    [self.scrollView addGestureRecognizer:self.animationTap];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.ktpBlockView waveAnimationFromPoint:textField.frame.origin];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.usernameInput]) {
        [self setFocusOnTextField:self.passwordInput];
    } else if ([textField isEqual:self.passwordInput]) {
        [self removeFocusFromTextField:self.passwordInput];
    }
    return YES;
}

-(void)touchDownOnView:(UITapGestureRecognizer *)tap
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

-(void)removeFocusFromTextField:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)setFocusOnTextField:(UITextField *)textField
{
    [textField becomeFirstResponder];
    //    [self.scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
}

-(void)tappedLogIn
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
