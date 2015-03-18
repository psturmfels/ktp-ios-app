//
//  KTPPieChart.h
//  KTP
//
//  Created by Owen Yang on 2/28/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTPPieChartTitlePosition) {
    KTPPieChartTitlePositionTop,
    KTPPieChartTitlePositionCenter,
    KTPPieChartTitlePositionBottom
};

@protocol KTPPieChartDataSource;
@protocol KTPPieChartDelegate;

@interface KTPPieChart : UIView

@property (nonatomic, weak) id<KTPPieChartDataSource> dataSource;
@property (nonatomic, weak) id<KTPPieChartDelegate> delegate;

/*!
 Outer radius of pie chart as a percentage of the maximum size of this view. Given as a value between 0.0 and 1.0
 */
@property (nonatomic, assign) CGFloat maxPieRadius;

/*!
 Inner radius of pie chart as a percentage of the maximum size of this view. Given as a value between 0.0 and 1.0
 */
@property (nonatomic, assign) CGFloat minPieRadius;

/*!
 Radius of slice text as a percentage of the maximum size of this view. Given as a value between 0.0 and 1.0
 */
@property (nonatomic, assign) CGFloat textRadius;

@property (nonatomic, strong) UIFont *textFont;                         // default: bold system font
@property (nonatomic, strong) UIColor *textColor;                       // default: black

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;                        // default: bold system font
@property (nonatomic, strong) UIColor *titleColor;                      // default: black
@property (nonatomic, assign) KTPPieChartTitlePosition titlePosition;   // default: KTPPieChartTitlePositionTop

- (void)reloadData;

@end

@protocol KTPPieChartDataSource <NSObject>
@required
- (NSUInteger)numberOfSlicesInPieChart:(KTPPieChart*)pieChart;
- (CGFloat)pieChart:(KTPPieChart*)pieChart valueForSliceAtIndex:(NSUInteger)index;

@optional
- (UIColor*)pieChart:(KTPPieChart*)pieChart colorForSliceAtIndex:(NSUInteger)index;
- (NSString*)pieChart:(KTPPieChart*)pieChart textForSliceAtIndex:(NSUInteger)index;
@end

@protocol KTPPieChartDelegate <NSObject>
@optional
- (void)pieChart:(KTPPieChart*)pieChart didSelectSliceAtIndex:(NSUInteger)index;
@end

