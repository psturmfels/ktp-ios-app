//
//  KTPPledgeMeeting.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeMeeting.h"

@implementation KTPPledgeMeeting

- (instancetype)initWithActive:(KTPMember*)active pledge:(KTPMember*)pledge complete:(BOOL)complete _id:(NSString*)_id {
    self = [super init];
    if (self) {
        self.active = active;
        self.pledge = pledge;
        self.complete = complete;
        self._id = _id;
    }
    return self;
}

@end
