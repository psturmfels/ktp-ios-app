//
//  KTPPledgeTaskDetailViewController.m
//  KTP
//
//  Created by Patrick Wilson on 2/16/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeTaskDetailViewController.h"
#import "KTPPledgeTask.h"



@interface KTPPledgeTaskDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end



@implementation KTPPledgeTaskDetailViewController

#pragma mark - Initialization

- (instancetype)initWithPledgeTask:(KTPPledgeTask *)pledgeTask {
    self = [super init];
    if (self) {
        self.pledgeTask = pledgeTask;
    }
    return self;
}

#pragma mark - Overriden Setters/Getters

/*!
 Overriden setter for member property. Sets the title of this VC to the first and last name of the member.
 
 @param         member
 */
- (void)setMember:(KTPPledgeTask *)pledgeTask {
    if (_pledgeTask != pledgeTask) {
        _pledgeTask = pledgeTask;
    }
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