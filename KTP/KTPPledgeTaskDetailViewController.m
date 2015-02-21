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
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descriptionDataLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UILabel *proofDataLabel;
@property (nonatomic, strong) UILabel *proofLabel;

@property (nonatomic, strong) UILabel *pointsDataLabel;
@property (nonatomic, strong) UILabel *pointsLabel;





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
    self.descriptionDataLabel.text = self.pledgeTask.taskDescription;
    self.proofDataLabel.text = self.pledgeTask.proof;
    self.pointsDataLabel.text = [NSString stringWithFormat:@"%.f/%.f",self.pledgeTask.pointsEarned,self.pledgeTask.points];
}

- (void)loadSubviews {
    [self loadScrollView];
    [self loadContentView];
    
    // Content Views
    [self loadTitleDataLabel];
    [self loadTitleLabel];
    [self loadDescriptionDataLabel];
    [self loadDescriptionLabel];
    [self loadProofDataLabel];
    [self loadProofLabel];
    [self loadPointsDataLabel];
    [self loadPointsLabel];
    
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

- (void)loadTitleDataLabel{
    self.titleDataLabel = [UILabel labelWithText:self.pledgeTask.taskTitle];
    [self.titleDataLabel setTextAlignment:NSTextAlignmentLeft];
    [self.titleDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.titleDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleDataLabel];
}

- (void)loadTitleLabel{
    self.titleLabel = [UILabel labelWithText:@"Task: "];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
}

- (void)loadDescriptionDataLabel{
    self.descriptionDataLabel = [UILabel labelWithText:self.pledgeTask.taskDescription];
    [self.descriptionDataLabel setTextAlignment:NSTextAlignmentLeft];
    [self.descriptionDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.descriptionDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.descriptionDataLabel];
}

- (void)loadDescriptionLabel{
    self.descriptionLabel = [UILabel labelWithText:@"Description: "];
    [self.descriptionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.descriptionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.descriptionLabel];
}

- (void)loadProofDataLabel{
    self.proofDataLabel = [UILabel labelWithText:self.pledgeTask.proof];
    [self.proofDataLabel setTextAlignment:NSTextAlignmentLeft];
    [self.proofDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.proofDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.proofDataLabel];
}

- (void)loadProofLabel{
    self.proofLabel = [UILabel labelWithText:@"Proof: "];
    [self.proofLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.proofLabel.numberOfLines = 0;
    [self.contentView addSubview:self.proofLabel];
}

- (void)loadPointsDataLabel{
    self.pointsDataLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%.f/%.f",self.pledgeTask.pointsEarned,self.pledgeTask.points]];
    [self.pointsDataLabel setTextAlignment:NSTextAlignmentLeft];
    [self.pointsDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.pointsDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.pointsDataLabel];
}

- (void)loadPointsLabel{
    self.pointsLabel = [UILabel labelWithText:@"Points Earned: "];
    [self.pointsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.pointsLabel.numberOfLines = 0;
    [self.contentView addSubview:self.pointsLabel];
}

- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"titleDataLabel"       :   self.titleDataLabel,
                            @"titleLabel"           :   self.titleLabel,
                            @"descriptionDataLabel" :   self.descriptionDataLabel,
                            @"descriptionLabel"     :   self.descriptionLabel,
                            @"proofDataLabel"       :   self.proofDataLabel,
                            @"proofLabel"           :   self.proofLabel,
                            @"pointsDataLabel"      :   self.pointsDataLabel,
                            @"pointsLabel"          :   self.pointsLabel
                            };
    
    /* titleDataLabel */
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleDataLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.titleDataLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleDataLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[titleLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleDataLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[titleLabel]-10-[titleDataLabel]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[descriptionLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleDataLabel]-10-[descriptionLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[descriptionDataLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[descriptionLabel]-10-[descriptionDataLabel]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[proofLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[descriptionDataLabel]-10-[proofLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[proofDataLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[proofLabel]-10-[proofDataLabel]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[pointsLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[proofDataLabel]-10-[pointsLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[pointsDataLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointsLabel]-10-[pointsDataLabel]" options:0 metrics:nil views:views]];
    
    
    
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