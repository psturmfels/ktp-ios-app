//
//  KTPPitchesViewController.m
//  KTP
//
//  Created by Owen Yang on 1/28/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchesViewController.h"
#import "KTPPitchesCell.h"
#import "KTPPitchesDataSource.h"
#import "KTPPitchAddViewController.h"
#import "KTPPitchVoteViewController.h"

@interface KTPPitchesViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KTPPitchesDataSource *dataSource;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation KTPPitchesViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePitchesTableView) name:KTPNotificationPitchesUpdated object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitchAlreadyVotedAlert) name:KTPNotificationPitchAlreadyVoted object:nil];
        self.navigationItem.title = @"Pitches";
        
        [self initTableView];
        [self initPullToRefresh];
    }
    return self;
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[KTPPitchesCell class] forCellReuseIdentifier:@"PitchCell"];
    self.tableView.delegate = self;
    self.dataSource = [KTPPitchesDataSource new];
    self.tableView.dataSource = self.dataSource;
}

- (void)initPullToRefresh {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self.dataSource action:@selector(reloadPitches) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPitchButtonTapped)];
    
    // Add pitches tableview as subview
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[KTPPitchVoteViewController alloc] initWithPitch:self.dataSource.pitchArray[indexPath.row]]
                                         animated:YES];
}

- (void)addPitchButtonTapped {
    KTPPitchAddViewController *pitchAddVC = [KTPPitchAddViewController new];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:pitchAddVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - Notification Handling

- (void)updatePitchesTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)pitchAlreadyVotedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Already Voted" message:@"You already voted for this pitch" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
