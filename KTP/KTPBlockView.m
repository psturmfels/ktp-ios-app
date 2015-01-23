//
//  KTPBlockView.m
//  KTP
//
//  Created by Greg Azevedo on 2/16/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPBlockView.h"
@interface KTPBlockView ()
{
    CGFloat side;
    CGFloat space;
}
@property (nonatomic) UIBezierPath *square;
@property (nonatomic) UIBezierPath *trTriangle;
@property (nonatomic) UIBezierPath *tlTriangle;
@property (nonatomic) UIBezierPath *brTriangle;
@property (nonatomic) UIBezierPath *blTriangle;

@end

@implementation KTPBlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        side = frame.size.width/16;
        space = side/5;
        [self kappaLetter];
        [self thetaLetter];
        [self piLetter];
        [self animateAllBlocks];
    }
    return self;
}

-(CAShapeLayer *)blockInRow:(NSUInteger)row column:(NSUInteger)column path:(UIBezierPath *)path
{
    CAShapeLayer *block = [CAShapeLayer layer];
    block.frame = CGRectMake(column*(side+space), row*(side+space), side, side);
    block.fillColor = [UIColor KTPOpenGreen].CGColor;
    block.strokeColor = [UIColor whiteColor].CGColor;
    block.lineWidth = 0.5;
    block.path = path.CGPath;
    return block;
}

-(void)animateAllBlocks
{
    for (CALayer *block in self.layer.sublayers) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        CGFloat randNum = arc4random() % 100;
        CGFloat randPercent = (randNum)/100;
//        NSLog(@"rand num %f percent %f", randNum, randPercent);
        animation.toValue =  [NSNumber numberWithFloat:randPercent];
        animation.duration = randPercent;
        animation.autoreverses = YES;
        animation.repeatCount = 2;
        [block addAnimation:animation forKey:@"disco"];
    }
}

-(void)waveAnimationFromPoint:(CGPoint)point
{
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer *block, NSUInteger idx, BOOL *stop) {
        CGRect frame =[self.layer convertRect:block.frame toLayer:self.layer.superlayer];
        CGFloat xDist = fabsf(frame.origin.x - point.x);
        CGFloat yDist = fabsf(frame.origin.y - point.y);
        CGFloat dist = sqrtf(xDist*xDist + yDist*yDist);
        NSNumber *percent = [NSNumber numberWithFloat:dist/self.frame.size.height];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.toValue = @0;
        animation.duration = [percent floatValue];
        animation.autoreverses = YES;
        animation.repeatCount = 1;
        [block addAnimation:animation forKey:@"wave"];
//        NSLog(@"percent: %@ duration: %f alpha %@", percent, animation.duration, animation.toValue);
    }];

}

-(UIBezierPath *)trTriangle
{
    if (!_trTriangle) {
        _trTriangle = [UIBezierPath bezierPath];
        [_trTriangle moveToPoint:CGPointMake(0, 0)];
        [_trTriangle addLineToPoint:CGPointMake(side, 0)];
        [_trTriangle addLineToPoint:CGPointMake(side, side)];
        [_trTriangle addLineToPoint:CGPointMake(0, 0)];
    }
    return _trTriangle;
}

-(UIBezierPath *)brTriangle
{
    if (!_brTriangle) {
        _brTriangle = [UIBezierPath bezierPath];
        [_brTriangle moveToPoint:CGPointMake(0, side)];
        [_brTriangle addLineToPoint:CGPointMake(side, side)];
        [_brTriangle addLineToPoint:CGPointMake(side, 0)];
        [_brTriangle addLineToPoint:CGPointMake(0, side)];
    }
    return _brTriangle;
}

-(UIBezierPath *)tlTriangle
{
    if (!_tlTriangle) {
        _tlTriangle = [UIBezierPath bezierPath];
        [_tlTriangle moveToPoint:CGPointMake(0, 0)];
        [_tlTriangle addLineToPoint:CGPointMake(side, 0)];
        [_tlTriangle addLineToPoint:CGPointMake(0, side)];
        [_tlTriangle addLineToPoint:CGPointMake(0, 0)];
    }
    return _tlTriangle;
}

-(UIBezierPath *)blTriangle
{
    if (!_blTriangle) {
        _blTriangle = [UIBezierPath bezierPath];
        [_blTriangle moveToPoint:CGPointMake(0, 0)];
        [_blTriangle addLineToPoint:CGPointMake(0, side)];
        [_blTriangle addLineToPoint:CGPointMake(side, side)];
        [_blTriangle addLineToPoint:CGPointMake(0, 0)];
    }
    return _blTriangle;
}

-(UIBezierPath *)square
{
    if (!_square) {
        _square = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, side, side)];
    }
    return _square;
}

-(void)kappaLetter
{
    [self.layer addSublayer:[self blockInRow:0 column:0 path:self.square]];
    [self.layer addSublayer:[self blockInRow:1 column:0 path:self.square]];
    [self.layer addSublayer:[self blockInRow:2 column:0 path:self.square]];
    [self.layer addSublayer:[self blockInRow:3 column:0 path:self.square]];
    [self.layer addSublayer:[self blockInRow:4 column:0 path:self.square]];
    [self.layer addSublayer:[self blockInRow:1 column:1 path:self.brTriangle]];
    [self.layer addSublayer:[self blockInRow:2 column:1 path:self.square]];
    [self.layer addSublayer:[self blockInRow:3 column:1 path:self.trTriangle]];
    [self.layer addSublayer:[self blockInRow:0 column:2 path:self.brTriangle]];
    [self.layer addSublayer:[self blockInRow:1 column:2 path:self.tlTriangle]];
    [self.layer addSublayer:[self blockInRow:3 column:2 path:self.blTriangle]];
    [self.layer addSublayer:[self blockInRow:4 column:2 path:self.trTriangle]];
    [self.layer addSublayer:[self blockInRow:0 column:3 path:self.tlTriangle]];
    [self.layer addSublayer:[self blockInRow:4 column:3 path:self.blTriangle]];
}

-(void)thetaLetter
{
    [self.layer addSublayer:[self blockInRow:0 column:4 path:self.brTriangle]];
    [self.layer addSublayer:[self blockInRow:1 column:4 path:self.square]];
    [self.layer addSublayer:[self blockInRow:2 column:4 path:self.square]];
    [self.layer addSublayer:[self blockInRow:3 column:4 path:self.square]];
    [self.layer addSublayer:[self blockInRow:4 column:4 path:self.trTriangle]];
    [self.layer addSublayer:[self blockInRow:0 column:5 path:self.square]];
    [self.layer addSublayer:[self blockInRow:2 column:5 path:self.square]];
    [self.layer addSublayer:[self blockInRow:4 column:5 path:self.square]];
    [self.layer addSublayer:[self blockInRow:0 column:6 path:self.square]];
    [self.layer addSublayer:[self blockInRow:2 column:6 path:self.square]];
    [self.layer addSublayer:[self blockInRow:4 column:6 path:self.square]];
    [self.layer addSublayer:[self blockInRow:0 column:7 path:self.blTriangle]];
    [self.layer addSublayer:[self blockInRow:1 column:7 path:self.square]];
    [self.layer addSublayer:[self blockInRow:2 column:7 path:self.square]];
    [self.layer addSublayer:[self blockInRow:3 column:7 path:self.square]];
    [self.layer addSublayer:[self blockInRow:4 column:7 path:self.tlTriangle]];
}

-(void)piLetter
{
    [self.layer addSublayer:[self blockInRow:0 column:8 path:self.brTriangle]];
    [self.layer addSublayer:[self blockInRow:0 column:9 path:self.square]];
    [self.layer addSublayer:[self blockInRow:1 column:9 path:self.square]];
    [self.layer addSublayer:[self blockInRow:2 column:9 path:self.square]];
    [self.layer addSublayer:[self blockInRow:3 column:9 path:self.square]];
    [self.layer addSublayer:[self blockInRow:4 column:9 path:self.square]];
    [self.layer addSublayer:[self blockInRow:0 column:10 path:self.square]];
    [self.layer addSublayer:[self blockInRow:0 column:11 path:self.square]];
    [self.layer addSublayer:[self blockInRow:1 column:11 path:self.square]];
    [self.layer addSublayer:[self blockInRow:2 column:11 path:self.square]];
    [self.layer addSublayer:[self blockInRow:3 column:11 path:self.square]];
    [self.layer addSublayer:[self blockInRow:4 column:11 path:self.square]];
    [self.layer addSublayer:[self blockInRow:0 column:12 path:self.square]];
}

@end
