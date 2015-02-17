//
//  KTPPledgeTaskDetailViewController.m
//  KTP
//
//  Created by Patrick Wilson on 2/16/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeTaskDetailViewController.h"
#import "KTPPledgeTask.h"



@interface KTPPledgeTaskDetailViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleDataLabel;

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

- (void)viewDidAppear:(BOOL)animated{
    [self loadContent];
}

- (void)loadContent {
    self.titleDataLabel.text = self.pledgeTask.taskTitle;
}

- (void)loadSubviews {
    [self loadScrollView];
    [self loadContentView];
    
    // Content Views
    [self loadTitleLabel];
    
}

- (void)loadScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
}

- (void)loadContentView {
    CGRect frame = self.scrollView.bounds;
    frame.size.height = 1000;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.scrollView addSubview:self.contentView];
}

- (void)loadTitleLabel{
    self.titleDataLabel = [UILabel labelWithText:self.pledgeTask.taskTitle];
    [self.titleDataLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.titleDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleDataLabel];
}

- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"titleDataLabel"       :   self.titleDataLabel
                            };
    
    /* titleDataLabel */
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleDataLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.titleDataLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleDataLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleDataLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[titleDataLabel]" options:0 metrics:nil views:views]];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Get the top and bottom subviews of contentView
    UIView *topView, *bottomView;
    for (UIView *view in self.contentView.subviews) {
        if (!topView || topView.frame.origin.y > view.frame.origin.y) {
            topView = view;
        }
        if (!bottomView || bottomView.frame.origin.y + bottomView.frame.size.height < view.frame.origin.y + view.frame.size.height) {
            bottomView = view;
        }
    }
    
    // Resize contentView such that it is larger than its subviews
    CGRect frame = self.contentView.frame;
    frame.size.height = topView.frame.origin.y + bottomView.frame.origin.y + bottomView.frame.size.height + kContentViewBottomPadding;
    self.contentView.frame = frame;
    
    // Set the content size of scrollView to contentView's size
    self.scrollView.contentSize = self.contentView.frame.size;
}
@end