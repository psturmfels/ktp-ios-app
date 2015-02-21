//
//  KTPPledgeTasksViewController.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeTasksViewController.h"
#import "KTPPledgeTaskDetailViewController.h"
#import "KTP-Swift.h" // for KTPPledgeTasksCell
#import "KTPSPledgeTasks.h"

@interface KTPPledgeTasksViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation KTPPledgeTasksViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Tasks" image:[UIImage imageNamed:@"TasksTabBarIcon"] tag:0];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:KTPNotificationPledgeTasksUpdated object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self.refreshControl selector:@selector(endRefreshing) name:KTPNotificationPledgeTasksUpdateFailed object:nil];
        
        [self initPullToRefresh];
    }
    return self;
}

- (void)initPullToRefresh {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshPledgeTasks) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Pledge Tasks";
}

#pragma mark - Loading Subviews

- (void)loadTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[KTPPledgeTasksCell class] forCellReuseIdentifier:@"PledgeTasksCell"];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kStandardTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KTPPledgeTask *selectedPledgeTask = [KTPSPledgeTasks pledgeTasks].pledgeTasksArray[indexPath.row];
    [self showPledgeTaskDetailWithPledgeTask:selectedPledgeTask];
    
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPPledgeTasksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PledgeTasksCell" forIndexPath:indexPath];
    cell.task = [KTPSPledgeTasks pledgeTasks].pledgeTasksArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [KTPSPledgeTasks pledgeTasks].pledgeTasksArray.count;
}

#pragma mark - Notification Handling

- (void)updateTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - UI action selectors

- (void)refreshPledgeTasks {
    [[KTPSPledgeTasks pledgeTasks] reloadPledgeTasks];
}

#pragma mark - Showing KTPPledgeTaskView

/*!
 Initializes a KTPPledgeTaskViewController with a PledgeTask and pushes it onto the navigation stack
 
 @param         member
 */
- (void)showPledgeTaskDetailWithPledgeTask:(KTPPledgeTask*)pledgeTask {
    // Push a profile VC onto the navigation stack
    [self.navigationController pushViewController:[[KTPPledgeTaskDetailViewController alloc] initWithPledgeTask:pledgeTask] animated:YES];
}

@end
