//
//  NSIndexSet+IS5Helpers.m
//  iScore5
//
//  Created by Greg Azevedo on 11/10/14.
//  Copyright (c) 2014 iScore5 LLC. All rights reserved.
//

#import "NSIndexSet+KTPHelpers.h"

@implementation NSIndexSet (KTPHelpers)

- (NSUInteger)indexAtIndex:(NSUInteger)anIndex
{
    if (anIndex >= self.count) {
        return NSNotFound;
    }
    NSUInteger index = self.firstIndex;
    for (NSUInteger i = 0; i < anIndex; i++)
        index = [self indexGreaterThanIndex:index];
    return index;
}
@end
