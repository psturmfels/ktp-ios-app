//
//  KTPTextField.m
//  KTP
//
//  Created by Greg Azevedo on 8/27/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPTextField.h"

@implementation KTPTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:5];

    }
    return self;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 5);
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
