//
//  KTPRequirementsViewController.m
//  KTP
//
//  Created by Greg Azevedo on 8/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPRequirementsViewController.h"
#import "KTPRequirementsDataSource.h"


@interface KTPRequirementsViewController () <UITableViewDelegate>

@property (nonatomic) UITableView *checklist;
@property (nonatomic) KTPRequirementsDataSource *dataSource;

@end

@implementation KTPRequirementsViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    self.dataSource = [KTPRequirementsDataSource new];
    self.checklist = [UITableView new];
    [self.checklist registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.checklist setFrame:self.view.frame];
    [self.checklist setDelegate:self];
    [self.checklist setDataSource:self.dataSource];
    [self.view addSubview:self.checklist];
    
    self.navigationItem.title = @"Requirements";
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.checklist reloadData];
}

#pragma mark - TABLE VIEW DELEGATE


@end
