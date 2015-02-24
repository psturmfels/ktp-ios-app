//
//  KTPEditPledgeTaskViewController.m
//  KTP
//
//  Created by Owen Yang on 2/21/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPEditPledgeTaskViewController.h"

@interface KTPEditPledgeTaskViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation KTPEditPledgeTaskViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.navigationItem.title = @"Edit Task";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    }
    return self;
}

- (instancetype)initWithPledgeTask:(KTPPledgeTask*)pledgeTask {
    self = [self init];
    if (self) {
        self.pledgeTask = pledgeTask;
    }
    return self;
}

#pragma mark - Overridden Setters/Getters

- (void)setPledgeTask:(KTPPledgeTask *)pledgeTask {
    if (_pledgeTask != pledgeTask) {
        _pledgeTask = pledgeTask;
        
        // CUSTOM ACTIONS
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate methods

// PLACE DELEGATE METHODS HERE

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;   // PLACEHOLDER TO ALLOW COMPILATION
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];   // PLACEHOLDER TO ALLOW COMPILATION
}

#pragma mark - UI action selectors

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped {
    // Update the task
    
    
    // Upon completing the update, dismiss this view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
