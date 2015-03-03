//
// MPPieLayer.h
// MagicPie
//
// Copyright (c) 2013 Alexandr Graschenkov ( https://github.com/Sk0rpion )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MPShowText) {
    MPShowTextNever,
    MPShowTextIfEnabled,
    MPShowTextAlways
};

@class MPPieElement;
@interface MPPieLayer : CALayer

@property (nonatomic, strong, readonly) NSArray* values;
- (void)addValues:(NSArray*)addingNewValues animated:(BOOL)animated;
- (void)deleteValues:(NSArray*)valuesToDelete animated:(BOOL)animated;
- (void)insertValues:(NSArray *)array atIndexes:(NSArray*)indexes animated:(BOOL)animated;

@property (nonatomic, assign) CGFloat maxRadius;              // default: 100
@property (nonatomic, assign) CGFloat minRadius;              // default: 0
@property (nonatomic, assign) CGFloat startAngle;             // default: 0 (degrees)
@property (nonatomic, assign) CGFloat endAngle;               // default: 360 (degrees)
@property (nonatomic, assign) CGFloat animationDuration;      // default: 0.6
@property (nonatomic, assign) MPShowText showText;          // default: ShowTextAlways

@property (nonatomic, assign) CGFloat textRadius;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) NSString*(^transformTextBlock)(MPPieElement *element, CGFloat percent);

- (void)setMaxRadius:(CGFloat)maxRadius minRadius:(CGFloat)minRadius textRadius:(CGFloat)textRadius animated:(BOOL)isAnimated;
- (void)setStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle animated:(BOOL)isAnimated;

- (MPPieElement*)pieElementAtPoint:(CGPoint)point;

//you can redefine draw elements
- (void)drawElement:(MPPieElement*)elem context:(CGContextRef)ctx;

@end
