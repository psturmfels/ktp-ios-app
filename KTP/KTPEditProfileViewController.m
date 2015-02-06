//
//  KTPEditProfileViewController.m
//  KTP
//
//  Created by Owen Yang on 2/2/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPEditProfileViewController.h"
#import "KTPMember.h"
#import "KTPNetworking.h"
#import "KTPEditProfileViewCell.h"

@interface KTPEditProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/*
 Add any additional properties as needed
 */

@end

@implementation KTPEditProfileViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Edit Profile";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    }
    return self;
}

- (instancetype)initWithMember:(KTPMember*)member {
    self = [self init];
    if (self) {
        self.member = member;
    }
    return self;
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
    [self.tableView registerClass:[KTPEditProfileViewCell class] forCellReuseIdentifier:@"MemberEditCell"];
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // IMPLEMENT
    
    KTPEditProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberEditCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        switch(indexPath.row) {
            case 0:
                cell.textField.placeholder = @"First Name";
                cell.textField.text = self.member.firstName;
                break;
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                break;
            case 5:
                break;
            case 6:
                break;
            case 7:
                break;
            case 8:
                break;
            default:
                break;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section) {
        case 0:
            return 8;
        case 1:
            return 2;
        case 2:
            return 2;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Personal";
        case 1:
            return @"Fraternity";
        case 2:
            return @"Contact";
        default:
            return nil;
    }
}

#pragma mark - UI action selectors

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*!
 Called when the done button is tapped. Makes a request to the KTP API to update the member's profile information. Displays an alert if there was an error when updating. Otherwise, dismisses the view controller after the request is complete.
 */
- (void)doneButtonTapped {
    // IMPLEMENT
    NSLog(@"done button tapped");
}



@end
