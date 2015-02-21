//
//  KTPPledgeTaskViewController.m
//  KTP
//
//  Created by Patrick Wilson on 2/16/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeTaskViewController.h"
#import "KTPPledgeTask.h"
#import "KTPEditPledgeTaskViewController.h"
#import "KTPSUser.h"


@interface KTPPledgeTaskViewController () <UINavigationControllerDelegate>

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

@property (nonatomic, strong) UILabel *minPledgeDataLabel;
@property (nonatomic, strong) UILabel *minPledgeLabel;

@property (nonatomic, strong) UILabel *repeatableDataLabel;
@property (nonatomic, strong) UILabel *repeatableLabel;

@property (nonatomic, strong) UILabel *pledgesInvolvedDataLabel;
@property (nonatomic, strong) UILabel *pledgesInvolvedLabel;

@end



@implementation KTPPledgeTaskViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Task";
        
        if ([KTPSUser currentUserIsAdmin]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped)];
        }
    }
    return self;
}

- (instancetype)initWithPledgeTask:(KTPPledgeTask *)pledgeTask {
    self = [self init];
    if (self) {
        self.pledgeTask = pledgeTask;
    }
    return self;
}

#pragma mark - Overriden Setters/Getters

/*!
 Overriden setter for member property.
 
 @param         member
 */
- (void)setPledgeTask:(KTPPledgeTask *)pledgeTask {
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
    self.minPledgeDataLabel.text = [NSString stringWithFormat:@"%@",@(self.pledgeTask.minimumPledges)];
    self.repeatableDataLabel.text = [NSString stringWithFormat:@"%@",(self.pledgeTask.repeatable?@"Yes":@"No")];
    self.pledgesInvolvedDataLabel.text = [NSString stringWithFormat:@"%@",(([self.pledgeTask.pledges count]>0)?@"Some people actually did this":@"NA")];
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
    [self loadMinPledgeDataLabel];
    [self loadMinPledgeLabel];
    [self loadRepeatableDataLabel];
    [self loadRepeatableLabel];
    [self loadPledgesInvolvedDataLabel];
    [self loadPledgesInvolvedLabel];
    
    
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

- (void)loadMinPledgeDataLabel{
    self.minPledgeDataLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@",@(self.pledgeTask.minimumPledges)]];
    [self.minPledgeDataLabel setTextAlignment:NSTextAlignmentLeft];
    [self.minPledgeDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.minPledgeDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.minPledgeDataLabel];
}

- (void)loadMinPledgeLabel{
    self.minPledgeLabel = [UILabel labelWithText:@"Min # of Pledges Required: "];
    [self.minPledgeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.minPledgeLabel.numberOfLines = 0;
    [self.contentView addSubview:self.minPledgeLabel];
}

- (void)loadRepeatableDataLabel{
    self.repeatableDataLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@",(self.pledgeTask.repeatable?@"Yes":@"No")]];
    [self.repeatableDataLabel setTextAlignment:NSTextAlignmentLeft];
    [self.repeatableDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.repeatableDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.repeatableDataLabel];
}

- (void)loadRepeatableLabel{
    self.repeatableLabel = [UILabel labelWithText:@"Repeatable: "];
    [self.repeatableLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.repeatableLabel.numberOfLines = 0;
    [self.contentView addSubview:self.repeatableLabel];
}

- (void)loadPledgesInvolvedDataLabel{
    self.pledgesInvolvedDataLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@",(([self.pledgeTask.pledges count]>0)?@"Some people actually did this":@"NA")]];
    [self.pledgesInvolvedDataLabel setTextAlignment:NSTextAlignmentLeft];
    [self.pledgesInvolvedDataLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.pledgesInvolvedDataLabel.numberOfLines = 0;
    [self.contentView addSubview:self.pledgesInvolvedDataLabel];
}

- (void)loadPledgesInvolvedLabel{
    self.pledgesInvolvedLabel = [UILabel labelWithText:@"Pledges Involved: "];
    [self.pledgesInvolvedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.pledgesInvolvedLabel.numberOfLines = 0;
    [self.contentView addSubview:self.pledgesInvolvedLabel];
}

- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"titleDataLabel"           :   self.titleDataLabel,
                            @"titleLabel"               :   self.titleLabel,
                            @"descriptionDataLabel"     :   self.descriptionDataLabel,
                            @"descriptionLabel"         :   self.descriptionLabel,
                            @"proofDataLabel"           :   self.proofDataLabel,
                            @"proofLabel"               :   self.proofLabel,
                            @"pointsDataLabel"          :   self.pointsDataLabel,
                            @"pointsLabel"              :   self.pointsLabel,
                            @"minPledgeDataLabel"       :   self.minPledgeDataLabel,
                            @"minPledgeLabel"           :   self.minPledgeLabel,
                            @"repeatableDataLabel"      :   self.repeatableDataLabel,
                            @"repeatableLabel"          :   self.repeatableLabel,
                            @"pledgesInvolvedDataLabel" :   self.pledgesInvolvedDataLabel,
                            @"pledgesInvolvedLabel"     :   self.pledgesInvolvedLabel
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
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[minPledgeLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointsDataLabel]-10-[minPledgeLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[minPledgeDataLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minPledgeLabel]-10-[minPledgeDataLabel]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[repeatableLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minPledgeDataLabel]-10-[repeatableLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[repeatableDataLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[repeatableLabel]-10-[repeatableDataLabel]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[pledgesInvolvedLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[repeatableDataLabel]-10-[pledgesInvolvedLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[pledgesInvolvedDataLabel]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pledgesInvolvedLabel]-10-[pledgesInvolvedDataLabel]" options:0 metrics:nil views:views]];
    
    
    
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

- (void)editButtonTapped {
    KTPEditPledgeTaskViewController *editVC = [[KTPEditPledgeTaskViewController alloc] initWithPledgeTask:self.pledgeTask];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:editVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end