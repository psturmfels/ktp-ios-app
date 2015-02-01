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
#import "KTPNetworking.h"

@interface KTPPitch ()

@end

@implementation KTPPitch

- (instancetype)init {
    self = [super init];
    if (self) {
        self.votes = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithMember:(KTPMember*)member title:(NSString*)title description:(NSString*)description votes:(NSMutableArray*)votes _id:(NSString*)_id {
    self = [self init];
    if (self) {
        self.member = member;
        self.pitchTitle = title;
        self.pitchDescription = description;
        self.votes = votes;
        self._id = _id;
    }
    return self;
}

/*!
 Adds a vote to the pitch and updates the database.
 
 @param         vote    The vote to add
 */
- (void)addVote:(KTPPitchVote*)vote {
    [self.votes addObject:vote];
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePUT toRoute:KTPRequestRouteAPIPitches appending:self._id parameters:nil withBody:[self JSONObject] block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPitchVotedSuccess object:self userInfo:@{@"pitch" : self}];
        } else {
            NSLog(@"Pitch vote was not sent with error: %@", error.userInfo);
            [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPitchVotedFailure object:self];
        }
    }];
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
    return @{
             @"member"      :   self.member._id,
             @"title"       :   self.pitchTitle,
             @"description" :   self.pitchDescription,
             @"votes"       :   votes
             };
}

@end
