//
// MPPieElement.m
// MagicPie
//
// Created by Alexandr on 03.11.13.
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

#import "MPPieElement.h"

NSString* const PieElementChangedNotificationIdentifier = @"PieElementChangedNotificationIdentifier";
NSString* const PieElementAnimateChangesNotificationIdentifier = @"PieElementAnimateChangesNotificationIdentifier";

static BOOL animateChanges;

@protocol PieLayerUpdateProtocol <NSObject>
- (void)pieElementUpdate;
- (void)pieElementWillAnimateUpdate;
@end

@interface MPPieElement()
@property (nonatomic, strong) NSMutableArray *containsInLayers;
@property (nonatomic, assign) CGFloat textAlpha;
@end

@implementation MPPieElement

+ (instancetype)pieElementWithValue:(CGFloat)value color:(UIColor *)color
{
    MPPieElement *result = [self new];
    result.value = value;
    result.color = color;
    return result;
}

- (id)copyWithZone:(NSZone *)zone
{
    MPPieElement *another = [[[self class] allocWithZone:zone] init];
    [another fillWithPieElement:self];
    return another;
}

- (void)fillWithPieElement:(MPPieElement*)element
{
    self.value = element.value;
    self.color = element.color;
    self.centerOffset = element.centerOffset;
    self.showText = element.showText;
    self.textAlpha = element.textAlpha;
    self.text = element.text;
}

+ (void)animateChanges:(void (^)())changes
{
    animateChanges = YES;
    changes();
    animateChanges = NO;
}

- (NSArray*)animationValuesToPieElement:(MPPieElement*)element arrayCapacity:(NSUInteger)count
{
    if (count == 1) return @[element];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        CGFloat v = i / (CGFloat)(count - 1);
        UIColor *newColor = [self colorBetweenColor1:self.color color2:element.color value:v];
        MPPieElement *newElem = [self copy];
        newElem.val_ = (element.value - self.value) * v + self.value;
        newElem.color_ = newColor;
        [newElem setCentrOffset_: (element.centerOffset - self.centerOffset) * v + self.centerOffset];
        newElem.textAlpha = (element.textAlpha - self.textAlpha) * v + self.textAlpha;
        newElem.showText = self.showText;
        [result addObject:newElem];
    }
    return result;
}

- (void)addedToPieLayer:(id<PieLayerUpdateProtocol>)pieLayer
{
    if (!self.containsInLayers)
        self.containsInLayers = [NSMutableArray new];
    NSValue *wraper = [NSValue valueWithNonretainedObject:pieLayer];
    [self.containsInLayers addObject:wraper];
}

- (void)removedFromLayer:(id<PieLayerUpdateProtocol>)pieLayer
{
    [self.containsInLayers removeObject:pieLayer];
}

- (void)notifyPerformForAnimation
{
    for (NSValue *notRetainedVal in self.containsInLayers)
        [notRetainedVal.nonretainedObjectValue pieElementWillAnimateUpdate];
}

- (void)notifyUpdated
{
    for (NSValue *notRetainedVal in self.containsInLayers)
        [notRetainedVal.nonretainedObjectValue pieElementUpdate];
}

#pragma mark - Setters
- (void)setValue:(CGFloat)value
{
    if (value < 0) {
#ifdef DEBUG
        NSLog(@"[%@ %@]- Negative values not allowed: val=%f => 0.0", NSStringFromClass(self.class), NSStringFromSelector(_cmd), value);
#endif
        value = 0.0;
    }
    if (value == _value)
        return;
    
    if (animateChanges) {
        [self notifyPerformForAnimation];
    }
    _value = value;
    if (!animateChanges) {
        [self notifyUpdated];
    }
}
- (void)setVal_:(CGFloat)value
{
    _value = value;
}

- (void)setColor:(UIColor *)color
{
    if ([_color isEqual:color])
        return;
    if (animateChanges) {
        [self notifyPerformForAnimation];
    }
    _color = color;
    if (!animateChanges) {
        [self notifyUpdated];
    }
}
- (void)setColor_:(UIColor *)color
{
    _color = color;
}

- (void)setCenterOffset:(CGFloat)centerOffset
{
    if (_centerOffset == centerOffset)
        return;
    
    if (animateChanges) {
        [self notifyPerformForAnimation];
    }
    _centerOffset = centerOffset;
    if (!animateChanges) {
        [self notifyUpdated];
    }
}
- (void)setCentrOffset_:(CGFloat)centrOffset
{
    _centerOffset = centrOffset;
}

- (void)setShowText:(BOOL)showText
{
    if (_showText == showText)
        return;
    
    if (animateChanges) {
        [self notifyPerformForAnimation];
    }
    _showText = showText;
    if (!animateChanges) {
        [self notifyUpdated];
    }
}

#pragma mark - Helpers

- (UIColor*)colorBetweenColor1:(UIColor*)color1 color2:(UIColor*)color2 value:(CGFloat)value
{
    value = MIN(MAX(value, 0.0), 1.0);
    CGFloat red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 =0.0;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0, alpha2 =0.0;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    return [UIColor colorWithRed:(red2-red1)* value + red1
                           green:(green2-green1)*value + green1
                            blue:(blue2-blue1)*value + blue1
                           alpha:(alpha2-alpha1)*value + alpha1];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[%@: %f]", NSStringFromClass(self.class), self.value];
}

@end
