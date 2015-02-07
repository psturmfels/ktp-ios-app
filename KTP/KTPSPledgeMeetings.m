//
//  KTPSPledgeMeetings.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSPledgeMeetings.h"

@implementation KTPSPledgeMeetings


- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadPledgeMeetings];
    }
    return self;
}

+ (KTPSPledgeMeetings *)pledgeMeetings {
    static KTPSPledgeMeetings *pledgeMeetings;
    static dispatch_once_t pledgeMeetingsToken;
    dispatch_once(&pledgeMeetingsToken, ^{
        pledgeMeetings = [self new];
    });
    return pledgeMeetings;
}

- (void)reloadPledgeMeetings {
    
}

@end
