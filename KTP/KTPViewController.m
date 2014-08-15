//
//  KTPViewController.m
//  KTP
//
//  Created by Gregory Azevedo on 1/18/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPViewController.h"

@interface KTPViewController () <UITextFieldDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITextField *usernameInput;
@property (nonatomic) UITextField *passwordInput;
@property (nonatomic) UIButton *logInButton;

@end

@implementation KTPViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)loadView
{
    [super loadView];
    self.scrollView = [UIScrollView new];
    [self.scrollView setFrame:self.view.frame];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setBackgroundColor:[UIColor KTPDarkGray]];
    [self.view addSubview:self.scrollView];
    
    self.ktpBlockView = [[KTPBlockView alloc] initWithFrame:CGRectMake(25, 100, self.view.frame.size.width-40, self.view.frame.size.height/2)];
    [self.scrollView addSubview:self.ktpBlockView];
    
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width-100, 50);
    
    self.usernameInput = [UITextField new];
    [self.usernameInput setFrame:textRect];
    [self.usernameInput setCenter:CGPointMake(self.scrollView.center.x, 300)];
    [self.usernameInput setPlaceholder:@" Username"];
    [self.usernameInput setBackgroundColor:[UIColor whiteColor]];
    [self.usernameInput setDelegate:self];
    [self.scrollView addSubview:self.usernameInput];
    self.usernameInput.layer.cornerRadius = 5;

    self.passwordInput = [UITextField new];
    [self.passwordInput setFrame:textRect];
    [self.passwordInput setCenter:CGPointMake(self.scrollView.center.x, 360)];
    [self.passwordInput setPlaceholder:@" Password"];
    [self.passwordInput setBackgroundColor:[UIColor whiteColor]];
    [self.passwordInput setDelegate:self];
    [self.scrollView addSubview:self.passwordInput];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.passwordInput.bounds];
    self.passwordInput.layer.masksToBounds = NO;
    self.passwordInput.layer.shadowColor = [UIColor blackColor].CGColor;
    self.passwordInput.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.passwordInput.layer.shadowOpacity = 0.1f;
    self.passwordInput.layer.shadowPath = shadowPath.CGPath;
    self.passwordInput.layer.cornerRadius = 5;
    
    
    self.logInButton = [UIButton new];
    [self.logInButton setFrame:textRect];
    [self.logInButton setCenter:CGPointMake(self.scrollView.center.x, 420)];
    [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.logInButton setTitleColor:[UIColor KTPOpenGreen] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.logInButton];
//    [self setAutoLayoutConstraints];
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
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.usernameInput]) {
        [self.passwordInput becomeFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    } else if ([textField isEqual:self.passwordInput]) {
        [self.passwordInput resignFirstResponder];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    return YES;
}


@end
