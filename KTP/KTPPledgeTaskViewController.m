//
//  KTPPledgeTaskViewController.m
//  KTP
//
//  Created by Owen Yang on 2/7/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeTaskViewController.h"
#import "KTPPledgeTask.h"

@interface KTPPledgeTaskViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation KTPPledgeTaskViewController

#pragma mark - Initialization

- (instancetype)initWithPledgeTask:(KTPPledgeTask*)pledgeTask {
    self = [super init];
    if (self) {
        self.pledgeTask = pledgeTask;
        self.navigationItem.title = @"Pledge Task";
    }
    return self;
}

#pragma mark - Loading Subviews

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadSubviews];
    [self autoLayoutSubviews];
}

- (void)loadSubviews {
    [self loadScrollView];
    [self loadContentView];
    
    // IMPLEMENT
}

- (void)loadScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
}

- (void)loadContentView {
    self.contentView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.scrollView addSubview:self.contentView];
}

- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // IMPLEMENT
    
    NSDictionary *views = @{
                            
                            };
    
    
}


@end
