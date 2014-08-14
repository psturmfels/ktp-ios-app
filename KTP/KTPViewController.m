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

-(void)loadView
{
    [super loadView];
    self.scrollView = [UIScrollView new];
    [self.scrollView setFrame:self.view.frame];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    
    self.ktpBlockView = [[KTPBlockView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, self.view.frame.size.height/2)];
    [self.scrollView addSubview:self.ktpBlockView];
    
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width-100, 50);
    
    self.usernameInput = [UITextField new];
    [self.usernameInput setFrame:textRect];
    [self.usernameInput setCenter:CGPointMake(self.scrollView.center.x, 200)];
    [self.usernameInput setPlaceholder:@"Username"];
    [self.usernameInput setBackgroundColor:[UIColor KTPGreen363]];
    [self.usernameInput setDelegate:self];
    [self.scrollView addSubview:self.usernameInput];
    
    self.passwordInput = [UITextField new];
    [self.passwordInput setFrame:textRect];
    [self.passwordInput setCenter:CGPointMake(self.scrollView.center.x, 300)];
    [self.passwordInput setPlaceholder:@"Password"];
    [self.passwordInput setBackgroundColor:[UIColor KTPGreen1F1]];
    [self.passwordInput setDelegate:self];
    [self.scrollView addSubview:self.passwordInput];
    
    self.logInButton = [UIButton new];
    [self.logInButton setFrame:textRect];
    [self.logInButton setCenter:CGPointMake(self.scrollView.center.x, 400)];
    [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.logInButton setTitleColor:[UIColor KTPBlue25F] forState:UIControlStateNormal];
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
