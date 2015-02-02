//
//  KTPChangePasswordViewController.m
//  KTP
//
//  Created by Owen Yang on 2/2/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPChangePasswordViewController.h"
#import "KTPNetworking.h"
#import "KTPSUser.h"
#import "KTPMember.h"

@interface KTPChangePasswordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *passwordCurrent;
@property (nonatomic, strong) UITextField *passwordNew;
@property (nonatomic, strong) UITextField *passwordConfirm;

@end

@implementation KTPChangePasswordViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Change Password";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changePassword)];
        
        [self initTextFields];
    }
    return self;
}

- (void)initTextFields {
    self.passwordCurrent = [UITextField new];
    self.passwordCurrent.placeholder = @"Current Password";
    self.passwordNew = [UITextField new];
    self.passwordNew.placeholder = @"New Password";
    self.passwordConfirm = [UITextField new];
    self.passwordConfirm.placeholder = @"Confirm New Password";
    self.passwordCurrent.secureTextEntry = self.passwordNew.secureTextEntry = self.passwordConfirm.secureTextEntry = YES;
}

#pragma mark - Loading Subviews

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    CGRect frame = cell.contentView.frame;
    frame.origin.x += cell.separatorInset.left;
    frame.size.width -= cell.separatorInset.left;
    
    switch (indexPath.row) {
        case 0:
            [cell addSubview:self.passwordCurrent];
            self.passwordCurrent.frame = frame;
            break;
        case 1:
            [cell addSubview:self.passwordNew];
            self.passwordNew.frame = frame;
            break;
        case 2:
            [cell addSubview:self.passwordConfirm];
            self.passwordConfirm.frame = frame;
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - UI action selectors

- (void)changePassword {
    [self.view endEditing:YES];
    
    UIAlertController *alert;
    
    if (![self.passwordNew.text isEqualToString:self.passwordConfirm.text]) {
        alert = [UIAlertController alertControllerWithTitle:@"Passwords Don't Match" message:@"You did not correctly confirm your new password" preferredStyle:UIAlertControllerStyleAlert];
    } else if (self.passwordNew.text.length < 6) {
        alert = [UIAlertController alertControllerWithTitle:@"Invalid Password" message:@"Your password must be at least 6 characters long" preferredStyle:UIAlertControllerStyleAlert];
    }
    
    if (alert) {
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePOST
                                       toRoute:KTPRequestRouteAPIChangePassword
                                     appending:nil
                                    parameters:nil
                                      withBody:@{
                                                 @"account"         :   [KTPSUser currentUser].member.account,
                                                 @"oldPassword"     :   self.passwordCurrent.text,
                                                 @"newPassword"     :   self.passwordNew.text,
                                                 @"confirmPassword" :   self.passwordConfirm.text
                                                 }
                                         block:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        if (error) {
            alert.title = @"Password Not Changed";
            alert.message = @"There was an error when changing your password";
        } else {
            NSString *stringResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([stringResponse isEqualToString:@"password changed\n"]) {
                alert.title = @"Password Changed";
                alert.message = @"Your password was successfully changed";
            } else if ([stringResponse isEqualToString:@"invalid password\n"]) {
                alert.title = @"Password Not Changed";
                alert.message = @"Your current password is not correct";
            }
        }
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

@end
