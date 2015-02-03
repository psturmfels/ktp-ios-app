//
//  KTPEditProfileViewController.m
//  KTP
//
//  Created by Owen Yang on 2/2/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPEditProfileViewController.h"
#import "KTPMember.h"

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
    
    /*
     Add any additional tableview setup here as needed
     */
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // IMPLEMENT
    return [UITableViewCell new];   // placeholder to allow compilation
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // IMPLEMENT
    return 0;   // placeholder to allow compilation
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
