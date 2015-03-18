//
//  KTPPieChart.m
//  KTP
//
//  Created by Owen Yang on 2/28/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPieChart.h"
#import "MagicPie.h"

@interface KTPPieChart ()

@property (nonatomic, readonly, strong) MPPieLayer *layer;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation KTPPieChart

+ (Class)layerClass {
    return [MPPieLayer class];
}

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _minPieRadius = 0;
        _maxPieRadius = 1;
        _textRadius = 1;
        self.opaque = NO;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
        
        [self initTitle];
        [self initChart];
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return self;
}

- (void)initTitle {
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.titlePosition = KTPPieChartTitlePositionTop;
    self.titleFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    self.titleColor = [UIColor blackColor];
}

- (void)initChart {
    [self.layer setStartAngle:90 endAngle:-270 animated:NO];
    [self.layer setMaxRadius:[self rawRadiusFromPercentage:self.maxPieRadius]
                   minRadius:[self rawRadiusFromPercentage:self.minPieRadius]
                 textRadius:[self rawRadiusFromPercentage:self.textRadius]
                    animated:NO];
    
    self.textFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    self.layer.textRadius = [self rawRadiusFromPercentage:self.textRadius];
    
    self.layer.transformTextBlock = ^NSString*(MPPieElement *element, CGFloat percent) {
        return element.text;
    };
    self.layer.showText = MPShowTextAlways;
}

#pragma mark - Overridden setters/getters

- (void)setMaxPieRadius:(CGFloat)maxPieRadius {
    _maxPieRadius = MAX(MIN(maxPieRadius, 1.0), 0.0);
    [self.layer setMaxRadius:[self rawRadiusFromPercentage:maxPieRadius]
                   minRadius:[self rawRadiusFromPercentage:self.minPieRadius]
                 textRadius:[self rawRadiusFromPercentage:self.textRadius]
                    animated:YES];
}

- (void)setMinPieRadius:(CGFloat)minPieRadius {
    _minPieRadius = MAX(MIN(minPieRadius, 1.0), 0.0);
    [self.layer setMaxRadius:[self rawRadiusFromPercentage:self.maxPieRadius]
                   minRadius:[self rawRadiusFromPercentage:minPieRadius]
                 textRadius:[self rawRadiusFromPercentage:self.textRadius]
                    animated:YES];
}

- (void)setTextRadius:(CGFloat)labelRadius {
    _textRadius = MAX(MIN(labelRadius, 1.0), 0.0);
    [self.layer setMaxRadius:[self rawRadiusFromPercentage:self.maxPieRadius]
                   minRadius:[self rawRadiusFromPercentage:self.minPieRadius]
                 textRadius:[self rawRadiusFromPercentage:labelRadius]
                    animated:YES];
}

- (void)setTextFont:(UIFont *)textFont {
    self.layer.textFont = textFont;
}

- (UIFont *)textFont {
    return self.layer.textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    self.layer.textColor = textColor;
}

- (UIColor*)textColor {
    return self.layer.textColor;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString*)title {
    return self.titleLabel.text;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
}

- (UIFont*)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.titleLabel.textColor = titleColor;
}

- (UIColor*)titleColor {
    return self.titleLabel.textColor;
}

- (void)setTitlePosition:(KTPPieChartTitlePosition)titlePosition {
    if (_titlePosition != titlePosition) {
        _titlePosition = titlePosition;
        
        [self removeConstraints:self.constraints];
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    switch (self.titlePosition) {
        case KTPPieChartTitlePositionTop:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
            break;
        case KTPPieChartTitlePositionCenter:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
            break;
        case KTPPieChartTitlePositionBottom:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
            break;
    }
    
    [super updateConstraints];
}

/*!
 Returns the raw radius value from the given percentage. Percentage given between 0.0 and 1.0
 */
- (CGFloat)rawRadiusFromPercentage:(CGFloat)percentage {
    return percentage * MIN(self.frame.size.width, self.frame.size.height) * 0.5; // multiply by half since this is radius
}

- (void)reloadData {
    // if there is no data source, we can't load data
    if (!self.dataSource) {
        return;
    }
    
    // update existing slices
    NSUInteger numSlices = [self.dataSource numberOfSlicesInPieChart:self];
    [MPPieElement animateChanges:^{
        [self.layer.values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx < numSlices) {
                MPPieElement *element = (MPPieElement*)obj;
                element.value = [self.dataSource pieChart:self valueForSliceAtIndex:idx];
                element.color = [self.dataSource pieChart:self colorForSliceAtIndex:idx];
                element.text  = [self.dataSource pieChart:self textForSliceAtIndex:idx];
            } else {
                *stop = YES;
            }
        }];
    }];
    
    // add or remove slices
    if (self.layer.values.count < numSlices) {         // there are more elements now than before
        NSMutableArray *elements = [NSMutableArray new];
        for (NSUInteger i = self.layer.values.count; i < numSlices; ++i) {
            MPPieElement *element = [MPPieElement pieElementWithValue:[self.dataSource pieChart:self valueForSliceAtIndex:i]
                                                            color:[self.dataSource pieChart:self colorForSliceAtIndex:i]];
            element.text = [self.dataSource pieChart:self textForSliceAtIndex:i];
            element.showText = YES;
            [elements addObject:element];
        }
        [self.layer addValues:elements animated:YES];
    } else if (self.layer.values.count > numSlices) {  // there are fewer elements now than before
        NSRange range;
        range.location = numSlices;
        range.length = self.layer.values.count - numSlices;
        [self.layer deleteValues:[self.layer.values subarrayWithRange:range] animated:YES];
    }
}

#pragma mark - UI action selectors

- (void)viewTapped:(UITapGestureRecognizer*)tap {
    if (tap.state != UIGestureRecognizerStateEnded)
        return;
    
    MPPieElement *tappedElement = [self.layer pieElementAtPoint:[tap locationInView:tap.view]];
    if (!tappedElement) {
        return;
    }
    
    // if we tapped an element that is already offset, set tappedElement to nil so its offset gets reset
    if (tappedElement.centerOffset > 0) {
        tappedElement = nil;
    }
    
    [MPPieElement animateChanges:^{
        for (MPPieElement *elem in self.layer.values) {
            elem.centerOffset = (tappedElement == elem) ? 20 : 0;
        }
    }];
}

@end
