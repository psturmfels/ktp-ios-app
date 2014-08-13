//
//  KTPBlockView.m
//  KTP
//
//  Created by Greg Azevedo on 2/16/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPBlockView.h"

@implementation KTPBlockView

-(void)createBlock:(CAShapeLayer *)block WithFrame:(CGRect)frame
{
    block = [CAShapeLayer layer];
    block.frame = frame;
    block.fillColor = [UIColor KTPBlue25F].CGColor;
    block.path = [UIBezierPath bezierPathWithRect:block.bounds].CGPath;
    [self.layer addSublayer:block];
}

-(void)createBlock:(CAShapeLayer *)block WithFrame:(CGRect)frame Path:(UIBezierPath *)path
{
    block = [CAShapeLayer layer];
    block.frame = frame;
    block.fillColor = [UIColor KTPBlue25F].CGColor;
    block.path = path.CGPath;
    [self.layer addSublayer:block];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat side = frame.size.width/16;
        CGFloat space = side/5;
        
        UIBezierPath *trTri = [UIBezierPath bezierPath];
        [trTri moveToPoint:CGPointMake(0, 0)];
        [trTri addLineToPoint:CGPointMake(side, 0)];
        [trTri addLineToPoint:CGPointMake(side, side)];
        [trTri addLineToPoint:CGPointMake(0, 0)];
        
        UIBezierPath *brTri = [UIBezierPath bezierPath];
        [brTri moveToPoint:CGPointMake(0, side)];
        [brTri addLineToPoint:CGPointMake(side, side)];
        [brTri addLineToPoint:CGPointMake(side, 0)];
        [brTri addLineToPoint:CGPointMake(0, side)];
        
        UIBezierPath *blTri = [UIBezierPath bezierPath];
        [blTri moveToPoint:CGPointMake(0, 0)];
        [blTri addLineToPoint:CGPointMake(0, side)];
        [blTri addLineToPoint:CGPointMake(side, side)];
        [blTri addLineToPoint:CGPointMake(0, 0)];
        
        UIBezierPath *tlTri = [UIBezierPath bezierPath];
        [tlTri moveToPoint:CGPointMake(0, 0)];
        [tlTri addLineToPoint:CGPointMake(side, 0)];
        [tlTri addLineToPoint:CGPointMake(0, side)];
        [tlTri addLineToPoint:CGPointMake(0, 0)];
        
        
        //column 1
        [self createBlock:self.k11 WithFrame:CGRectMake(0, 0, side, side)];
        [self createBlock:self.k21 WithFrame:CGRectMake(0, 1*(side+space), side, side)];
        [self createBlock:self.k31 WithFrame:CGRectMake(0, 2*(side+space), side, side)];
        [self createBlock:self.k41 WithFrame:CGRectMake(0, 3*(side+space), side, side)];
        [self createBlock:self.k51 WithFrame:CGRectMake(0, 4*(side+space), side, side)];
        //column 2
        [self createBlock:self.k22 WithFrame:CGRectMake((side+space), 1*(side+space), side, side) Path:brTri];
        [self createBlock:self.k32 WithFrame:CGRectMake((side+space), 2*(side+space), side, side)];
        [self createBlock:self.k42 WithFrame:CGRectMake((side+space), 3*(side+space), side, side) Path:trTri];
        //column 3
        [self createBlock:self.k13 WithFrame:CGRectMake(2*(side+space), 0, side, side) Path:brTri];
        [self createBlock:self.k23 WithFrame:CGRectMake(2*(side+space), 1*(side+space), side, side) Path:tlTri];
        [self createBlock:self.k43 WithFrame:CGRectMake(2*(side+space), 3*(side+space), side, side) Path:blTri];
        [self createBlock:self.k53 WithFrame:CGRectMake(2*(side+space), 4*(side+space), side, side) Path:trTri];
        
        [self createBlock:self.k14 WithFrame:CGRectMake(3*(side+space), 0, side, side) Path:tlTri];
        [self createBlock:self.k54 WithFrame:CGRectMake(3*(side+space), 4*(side+space), side, side) Path:blTri];

        //column 4
        [self createBlock:self.t15 WithFrame:CGRectMake(4*(side+space), 0, side, side) Path:brTri];
        [self createBlock:self.t25 WithFrame:CGRectMake(4*(side+space), 1*(side+space), side, side)];
        [self createBlock:self.t35 WithFrame:CGRectMake(4*(side+space), 2*(side+space), side, side)];
        [self createBlock:self.t45 WithFrame:CGRectMake(4*(side+space), 3*(side+space), side, side)];
        [self createBlock:self.t55 WithFrame:CGRectMake(4*(side+space), 4*(side+space), side, side) Path:trTri];
        //column 5
        [self createBlock:self.t16 WithFrame:CGRectMake(5*(side+space), 0, side, side)];
        [self createBlock:self.t36 WithFrame:CGRectMake(5*(side+space), 2*(side+space), side, side)];
        [self createBlock:self.t56 WithFrame:CGRectMake(5*(side+space), 4*(side+space), side, side)];
        //column 6
        [self createBlock:self.tt16 WithFrame:CGRectMake(6*(side+space), 0, side, side)];
        [self createBlock:self.tt36 WithFrame:CGRectMake(6*(side+space), 2*(side+space), side, side)];
        [self createBlock:self.tt56 WithFrame:CGRectMake(6*(side+space), 4*(side+space), side, side)];
        //column 7
        [self createBlock:self.t17 WithFrame:CGRectMake(7*(side+space), 0, side, side) Path:blTri];
        [self createBlock:self.t27 WithFrame:CGRectMake(7*(side+space), 1*(side+space), side, side)];
        [self createBlock:self.t37 WithFrame:CGRectMake(7*(side+space), 2*(side+space), side, side)];
        [self createBlock:self.t47 WithFrame:CGRectMake(7*(side+space), 3*(side+space), side, side)];
        [self createBlock:self.t57 WithFrame:CGRectMake(7*(side+space), 4*(side+space), side, side) Path:tlTri];
        
        //column 8
        [self createBlock:self.p18 WithFrame:CGRectMake(8*(side+space), 0, side, side) Path:brTri];
        //column 9
        [self createBlock:self.p19 WithFrame:CGRectMake(9*(side+space), 0, side, side)];
        [self createBlock:self.p29 WithFrame:CGRectMake(9*(side+space), 1*(side+space), side, side)];
        [self createBlock:self.p39 WithFrame:CGRectMake(9*(side+space), 2*(side+space), side, side)];
        [self createBlock:self.p49 WithFrame:CGRectMake(9*(side+space), 3*(side+space), side, side)];
        [self createBlock:self.p59 WithFrame:CGRectMake(9*(side+space), 4*(side+space), side, side)];
        //column 10
        [self createBlock:self.p110 WithFrame:CGRectMake(10*(side+space), 0, side, side)];
        //column 11
        [self createBlock:self.p111 WithFrame:CGRectMake(11*(side+space), 0, side, side)];
        [self createBlock:self.p211 WithFrame:CGRectMake(11*(side+space), 1*(side+space), side, side)];
        [self createBlock:self.p311 WithFrame:CGRectMake(11*(side+space), 2*(side+space), side, side)];
        [self createBlock:self.p411 WithFrame:CGRectMake(11*(side+space), 3*(side+space), side, side)];
        [self createBlock:self.p511 WithFrame:CGRectMake(11*(side+space), 4*(side+space), side, side)];
        //column 12
        [self createBlock:self.p112 WithFrame:CGRectMake(12*(side+space), 0, side, side)];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
