//
//  KTPPitchesViewController.m
//  KTP
//
//  Created by Owen Yang on 1/28/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchesViewController.h"
#import "KTPPitchesCell.h"
#import "KTPPitchAddViewController.h"
#import "KTPPitchVoteViewController.h"
#import "KTPSPitches.h"
#import "KTPPitch.h"
#import "KTPMember.h"
#import "KTPPitchesResultViewController.h"

@interface KTPPitchesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIButton *pitchesResultsButton;

@end

@implementation KTPPitchesViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Instantiate singleton
        [KTPSPitches pitches];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePitchesTableView) name:KTPNotificationPitchesUpdated object:nil];
        self.navigationItem.title = @"Pitches";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPitchButtonTapped)];
        
        [self initTableView];
        [self initPullToRefresh];
    }
    return self;
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[KTPPitchesCell class] forCellReuseIdentifier:@"PitchCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)initPullToRefresh {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:[KTPSPitches pitches] action:@selector(reloadPitches) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Loading Subviews

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTableView];
    [self loadPitchResultsButton];
}

- (void)loadTableView {
    CGRect frame = self.view.bounds;
    frame.size.height -= kLargeButtonHeight;
    self.tableView.frame = frame;
    [self.view addSubview:self.tableView];
}

- (void)loadPitchResultsButton {
    CGRect frame = CGRectMake(self.tableView.frame.origin.x,
                              self.tableView.frame.origin.y + self.tableView.frame.size.height,
                              self.tableView.frame.size.width,
                              kLargeButtonHeight);
    self.pitchesResultsButton = [[UIButton alloc] initWithFrame:frame];
    [self.pitchesResultsButton addTarget:self action:@selector(pitchesResultsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.pitchesResultsButton setTitle:@"Results" forState:UIControlStateNormal];
    [self.pitchesResultsButton setBackgroundImage:[UIImage imageWithColor:[UIColor KTPGreen363]] forState:UIControlStateNormal];
    [self.pitchesResultsButton setBackgroundImage:[UIImage imageWithColor:[[UIColor KTPGreen363] colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
    [self.view addSubview:self.pitchesResultsButton];
}

#pragma mark - Notification Handling

- (void)updatePitchesTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[KTPPitchVoteViewController alloc] initWithPitch:[KTPSPitches pitches].pitchesArray[indexPath.row]]
                                         animated:YES];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchCell" forIndexPath:indexPath];
    
    KTPPitch *pitch = [KTPSPitches pitches].pitchesArray[indexPath.row];
    cell.textLabel.text = pitch.pitchTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", pitch.member.firstName, pitch.member.lastName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [KTPSPitches pitches].pitchesArray.count;
}

#pragma mark - UI action selectors

- (void)addPitchButtonTapped {
    KTPPitchAddViewController *pitchAddVC = [KTPPitchAddViewController new];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:pitchAddVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)pitchesResultsButtonTapped {
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[KTPPitchesResultViewController new]];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end
