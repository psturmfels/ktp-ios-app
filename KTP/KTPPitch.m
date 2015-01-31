//
//  KTPPitch.m
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitch.h"
#import "KTPPitchVote.h"
#import "KTPMember.h"
#import "KTPSUser.h"

@interface KTPPitch ()

@end

@implementation KTPPitch

- (instancetype)initWithMember:(KTPMember*)member {
    self = [super init];
    if (self) {
        self.member = member;
    }
    return self;
}

- (instancetype)initWithMember:(KTPMember*)member title:(NSString*)title description:(NSString*)description votes:(NSMutableArray*)votes {
    self = [self initWithMember:member];
    if (self) {
        self.pitchTitle = title;
        self.pitchDescription = description;
        self.votes = votes;
    }
    return self;
}

/*!
 Adds a vote to the pitch if the current user has not voted yet.
 
 @param         vote    The vote to add
 */
- (void)addVote:(KTPPitchVote*)vote {
    if (![self userDidVote]) {
        [self.votes addObject:vote];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPitchAlreadyVoted object:self];
    }
}

/*!
 Checks if the user already voted.
 
 @returns       YES if the user already voted, NO otherwise
 */
- (BOOL)userDidVote {
    for (KTPPitchVote *vote in self.votes) {
        if (vote.member == [KTPSUser currentUser].member) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary*)JSONObject {
    
    NSMutableArray *votes = [NSMutableArray new];
    for (KTPPitchVote *vote in self.votes) {
        [votes addObject:@{
                           @"member"            :   vote.member._id,
                           @"innovationScore"   :   [NSNumber numberWithUnsignedInteger:vote.innovationScore],
                           @"usefulnessScore"   :   [NSNumber numberWithUnsignedInteger:vote.usefulnessScore],
                           @"coolnessScore"     :   [NSNumber numberWithUnsignedInteger:vote.coolnessScore]
                           }];
    }
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:votes options:0 error:nil];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    
//    NSLog(@"%@", dict);
    
    
    return @{
             @"member"      :   self.member._id,
             @"title"       :   self.pitchTitle,
             @"description" :   self.pitchDescription,
             @"votes"       :   votes
             };
}

@end
