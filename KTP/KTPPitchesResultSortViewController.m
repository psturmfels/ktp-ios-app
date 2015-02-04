//
//  KTPPitchesResultSortViewController.m
//  KTP
//
//  Created by Owen Yang on 2/3/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchesResultSortViewController.h"

@interface KTPPitchesResultSortViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) KTPPitchesResultSortType sortType;

@end

@implementation KTPPitchesResultSortViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Sort";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    }
    return self;
}

- (instancetype)initWithSortType:(KTPPitchesResultSortType)sortType {
    self = [self init];
    if (self) {
        self.sortType = sortType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PitchesResultSortCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.sortType = (KTPPitchesResultSortType)indexPath.row;
    [self.tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchesResultSortCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Innovation";
            break;
        case 1:
            cell.textLabel.text = @"Usefulness";
            break;
        case 2:
            cell.textLabel.text = @"Coolness";
            break;
        case 3:
            cell.textLabel.text = @"Overall";
            break;
        default:
            break;
    }
    
    if ((KTPPitchesResultSortType)indexPath.row == self.sortType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark - UI action selectors

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(pitchesResultSortViewControllerDidFinishWithSortType:)]) {
        [self.delegate pitchesResultSortViewControllerDidFinishWithSortType:self.sortType];
    }
}

@end
