//
//  KTPPledgeTask.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeTask.h"

@implementation KTPPledgeTask

- (instancetype)initWithTitle:(NSString*)title
                  description:(NSString*)description
                        proof:(NSString*)proof
                       points:(CGFloat)points
                 pointsEarned:(CGFloat)pointsEarned
               minimumPledges:(NSUInteger)minimumPledges
                   repeatable:(BOOL)repeatable
                      pledges:(NSMutableArray*)pledges
                          _id:(NSString*)_id
{
    self = [super init];
    if (self) {
        self.taskTitle = title;
        self.taskDescription = description;
        self.proof = proof;
        self.points = points;
        self.pointsEarned = pointsEarned;
        self.minimumPledges = minimumPledges;
        self.repeatable = repeatable;
        self.pledges = pledges;
        self._id = _id;
    }
    return self;
}

@end
