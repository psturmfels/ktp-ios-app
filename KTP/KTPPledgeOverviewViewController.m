//
//  KTPPledgeOverviewViewController.m
//  KTP
//
//  Created by Owen Yang on 2/26/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeOverviewViewController.h"
#import "KTPSPledgeTasks.h"
#import "KTPPledgeTask.h"
#import "KTPPieChart.h"

@interface KTPPledgeOverviewViewController () <KTPPieChartDelegate, KTPPieChartDataSource>// <XYPieChartDelegate, XYPieChartDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) KTPPieChart *pointsPieChart;

@end

@implementation KTPPledgeOverviewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollView = [UIScrollView new];
        self.contentView = [UIView new];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Overview" image:[UIImage imageNamed:@"ChartIcon"] tag:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pledgeTasksDidUpdate) name:KTPNotificationPledgeTasksUpdated object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Overview";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self pledgeTasksDidUpdate]; // assume tasks have updated and handle accordingly
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}

- (void)loadSubviews {
    // Container views
    self.scrollView.frame = self.view.bounds;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
    
    self.contentView.frame = self.scrollView.bounds;
    [self.scrollView addSubview:self.contentView];
    
    // Content views
    [self loadPointsPieChart];
}

- (void)loadPointsPieChart {
    self.pointsPieChart = [KTPPieChart new];
    self.pointsPieChart.delegate = self;
    self.pointsPieChart.dataSource = self;
    self.pointsPieChart.textColor = [UIColor grayColor];
    self.pointsPieChart.title = @"Pledge Points";
    self.pointsPieChart.titlePosition = KTPPieChartTitlePositionCenter;
//    self.pointsPieChart.labelFont = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:self.pointsPieChart];
}

#pragma mark - KTPPieChartDataSource methods

- (NSUInteger)numberOfSlicesInPieChart:(KTPPieChart *)pieChart {
    return 2; // earned vs needed points
}

- (CGFloat)pieChart:(KTPPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    if (index == 0) {
        return [KTPSPledgeTasks pledgeTasks].totalPointsEarned;
    } else {
        return [KTPSPledgeTasks pledgeTasks].totalPointsNeeded - [KTPSPledgeTasks pledgeTasks].totalPointsEarned;
    }
}

- (UIColor *)pieChart:(KTPPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    if (index == 0) {
        return [UIColor colorWithRed:172/255.0 green:221/255.0 blue:168/255.0 alpha:1];
    } else {
        return [UIColor colorWithRed:238/255.0 green:181/255.0 blue:173/255.0 alpha:1];
    }
}

- (NSString *)pieChart:(KTPPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    CGFloat value = [self pieChart:pieChart valueForSliceAtIndex:index];
    return value ? [NSString stringWithFormat:@"%1.0f", value] : @"";
}

#pragma mark - KTPPieChartDelegate methods

- (void)pieChart:(KTPPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
    
}

#pragma mark - Layout Subviews

- (void)autoLayoutSubviews {
    self.pointsPieChart.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"pointsPieChart"  :   self.pointsPieChart
                            };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[pointsPieChart]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pointsPieChart attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.pointsPieChart attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[pointsPieChart]" options:0 metrics:nil views:views]];
}

- (void)viewWillLayoutSubviews {
    self.pointsPieChart.maxPieRadius = 0.75;
    self.pointsPieChart.minPieRadius = 0.20;
    self.pointsPieChart.textRadius  = (self.pointsPieChart.maxPieRadius + self.pointsPieChart.minPieRadius) / 2;
}

#pragma mark - Notification Handling

- (void)pledgeTasksDidUpdate {
    [self.pointsPieChart reloadData];
}


@end
