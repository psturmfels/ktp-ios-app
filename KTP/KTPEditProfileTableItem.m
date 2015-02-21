//
//  KTPEditProfileTableItem.m
//  KTP
//
//  Created by Greg Azevedo on 2/16/15.
//  Copyright (c) 2015 gregazevedo. All rights reserved.
//

#import "KTPEditProfileTableItem.h"

@implementation KTPEditProfileTableItem

-(NSString *)description {
    return [NSString stringWithFormat:@"%@: %@",self.placeholder, self.text];
}

@end
