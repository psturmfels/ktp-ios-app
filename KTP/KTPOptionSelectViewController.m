//
//  KTPOptionSelectViewController.m
//  KTP
//
//  Created by Owen Yang on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPOptionSelectViewController.h"

@interface KTPOptionSelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property UITableViewController *tableViewController;

@end

@implementation KTPOptionSelectViewController

- (instancetype)initWithOptions:(NSArray*)options selected:(NSUInteger)selected title:(NSString*)title {
    self = [super init];
    if (self) {
        self.options = options;
        self.selected = selected;
        
        self.tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        self.tableViewController.tableView.delegate = self;
        self.tableViewController.tableView.dataSource = self;
        [self.tableViewController.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OptionSelectCell"];
        self.viewControllers = @[self.tableViewController];
        
        self.tableViewController.navigationItem.title = title;
        self.tableViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
        self.tableViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    return [self initWithOptions:nil selected:0 title:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selected = indexPath.row;
    [self.tableViewController.tableView reloadData];
    
    if ([self.optionSelectDelegate respondsToSelector:@selector(optionSelectViewController:didSelectOptionAtIndex:)]) {
        [self.optionSelectDelegate optionSelectViewController:self didSelectOptionAtIndex:indexPath.row];
    }
    if ([self.optionSelectDelegate respondsToSelector:@selector(optionSelectViewController:didSelectOptionWithValue:)]) {
        [self.optionSelectDelegate optionSelectViewController:self didSelectOptionWithValue:self.options[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionSelectCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.options[indexPath.row];
    cell.accessoryType = self.selected == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UI action selectors

- (void)doneButtonTapped {
    if ([self.optionSelectDelegate respondsToSelector:@selector(optionSelectViewControllerDidTapDoneButton:)]) {
        [self.optionSelectDelegate optionSelectViewControllerDidTapDoneButton:self];
    }
}

- (void)cancelButtonTapped {
    if ([self.optionSelectDelegate respondsToSelector:@selector(optionSelectViewControllerDidTapCancelButton:)]) {
        [self.optionSelectDelegate optionSelectViewControllerDidTapCancelButton:self];
    }
}

@end
