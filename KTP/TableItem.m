//
//  TableItem.m
//  sampletable
//
//  Created by Greg Azevedo on 2/16/15.
//  Copyright (c) 2015 gregazevedo. All rights reserved.
//

#import "TableItem.h"

@implementation TableItem

-(NSString *)description {
    return [NSString stringWithFormat:@"%@: %@",self.placeholder, self.text];
}

@end
