//
//  KTPPitchVote.m
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchVote.h"
#import "KTPMember.h"

@implementation KTPPitchVote

- (instancetype)initWithMember:(KTPMember*)member innovationScore:(NSUInteger)innovationScore usefulnessScore:(NSUInteger)usefulnessScore coolnessScore:(NSUInteger)coolnessScore
{
    self = [super init];
    if (self) {
        self.member = member;
        self.innovationScore = innovationScore;
        self.usefulnessScore = usefulnessScore;
        self.coolnessScore = coolnessScore;
    }
    return self;
}

- (NSDictionary*)JSONObject {
    return @{
             @"member"            :   self.member._id,
             @"innovationScore"   :   [NSNumber numberWithUnsignedInteger:self.innovationScore],
             @"usefulnessScore"   :   [NSNumber numberWithUnsignedInteger:self.usefulnessScore],
             @"coolnessScore"     :   [NSNumber numberWithUnsignedInteger:self.coolnessScore]
             };
}

@end
