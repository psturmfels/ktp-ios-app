//
//  KTPPitchesResultViewController.m
//  KTP
//
//  Created by Owen Yang on 2/3/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchesResultViewController.h"
#import "KTPPitchesResultCell.h"
#import "KTPPitchesResultSortViewController.h"
#import "KTPSPitches.h"

@interface KTPPitchesResultViewController () <UITableViewDelegate, UITableViewDataSource, KTPPitchesResultSortDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) KTPPitchesResultSortType sortType;

@property (nonatomic, strong) NSArray *sortedPitches;
@end

@implementation KTPPitchesResultViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Results";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonTapped)];
        self.sortType = KTPPitchesResultSortTypeOverall;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[KTPPitchesResultCell class] forCellReuseIdentifier:@"PitchesResultCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kStandardTableViewCellHeight * 2;
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPPitchesResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchesResultCell" forIndexPath:indexPath];
    cell.pitch = self.sortedPitches[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedPitches.count;
}

#pragma mark - UI action selectors

- (void)doneButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sortButtonTapped {
    KTPPitchesResultSortViewController *sortVC = [[KTPPitchesResultSortViewController alloc] initWithSortType:self.sortType];
    sortVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:sortVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - KTPPitchesResultSortViewControllerDelegate methods

- (void)pitchesResultSortViewControllerDidFinishWithSortType:(KTPPitchesResultSortType)sortType {
    self.sortType = sortType;
}

- (void)setSortType:(KTPPitchesResultSortType)sortType {
    if (_sortType != sortType) {
        _sortType = sortType;
        
        NSString *sortKey;
        switch (sortType) {
            case KTPPitchesResultSortTypeInnovation:
                sortKey = @"innovationScore";
                break;
            case KTPPitchesResultSortTypeUsefulness:
                sortKey = @"usefulnessScore";
                break;
            case KTPPitchesResultSortTypeCoolness:
                sortKey = @"coolnessScore";
                break;
            case KTPPitchesResultSortTypeOverall:
                sortKey = @"overallScore";
                break;
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:NO];
        self.sortedPitches = [[KTPSPitches pitches].pitchesArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                
        [self.tableView reloadData];
    }
}

@end
