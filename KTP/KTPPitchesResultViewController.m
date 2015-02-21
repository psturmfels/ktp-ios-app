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
#import "KTPOptionSelectViewController.h"

@interface KTPPitchesResultViewController () <UITableViewDelegate, UITableViewDataSource, KTPPitchesResultSortDelegate, KTPOptionSelectDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *sortKey;

@property (nonatomic, strong) NSArray *sortedPitches;
@end

NSString *const KTPPitchesSortKeyOverall    = @"overallScore";
NSString *const KTPPitchesSortKeyInnovation = @"innovationScore";
NSString *const KTPPitchesSortKeyUsefulness = @"usefulnessScore";
NSString *const KTPPitchesSortKeyCoolness   = @"coolnessScore";

@implementation KTPPitchesResultViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Results";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonTapped)];
        self.sortKey = KTPPitchesSortKeyOverall;
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
    NSArray *options = @[@"Overall", @"Innovation", @"Usefulness", @"Coolness"];
    KTPOptionSelectViewController *controller = [[KTPOptionSelectViewController alloc] initWithOptions:options
                                                                                              selected:[options indexOfObject:[self sortOptionFromKey:self.sortKey]]
                                                                                                 title:@"Sort"];
    controller.optionSelectDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - KTPOptionSelectDelegate methods

- (void)optionSelectViewController:(KTPOptionSelectViewController *)controller didSelectOptionWithValue:(id)value {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *selected = (NSString*)value;
    if ([selected isEqualToString:@"Overall"]) {
        self.sortKey = KTPPitchesSortKeyOverall;
    } else if ([selected isEqualToString:@"Innovation"]) {
        self.sortKey = KTPPitchesSortKeyInnovation;
    } else if ([selected isEqualToString:@"Usefulness"]) {
        self.sortKey = KTPPitchesSortKeyUsefulness;
    } else {
        self.sortKey = KTPPitchesSortKeyCoolness;
    }
}
                                                 
- (NSString*)sortOptionFromKey:(NSString*)key {
    if ([key isEqualToString:KTPPitchesSortKeyOverall]) {
        return @"Overall";
    } else if ([key isEqualToString:KTPPitchesSortKeyInnovation]) {
        return @"Innovation";
    } else if ([key isEqualToString:KTPPitchesSortKeyUsefulness]) {
        return @"Usefulness";
    } else {
        return @"Coolness";
    }
}

- (void)optionSelectViewControllerDidTapCancelButton:(KTPOptionSelectViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)optionSelectViewControllerDidTapDoneButton:(KTPOptionSelectViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSortKey:(NSString *)sortKey {
    if (_sortKey != sortKey) {
        _sortKey = sortKey;
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:self.sortKey ascending:NO];
        self.sortedPitches = [[KTPSPitches pitches].pitchesArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        [self.tableView reloadData];
    }
}

@end
