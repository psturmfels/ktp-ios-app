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

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObservers];
        self.votes = [[NSMutableArray new] mutableArrayValueForKey:@"votes"];
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

#pragma mark - Voting

/*!
 Adds a vote to this pitch. Also updates the KTP database
 
 @param         vote    The vote to add to this pitch
 */
- (void)addVote:(KTPPitchVote*)vote {
    [self.votes addObject:vote];
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePOST toRoute:KTPRequestRouteAPIPitches appending:[NSString stringWithFormat:@"%@/vote", self._id] parameters:nil withJSONBody:[vote JSONObject] block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPitchVotedSuccess object:self userInfo:@{@"pitch" : self}];
        } else {
            NSLog(@"Pitch vote was not sent with error: %@", error.userInfo);
            [self.votes removeLastObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPitchVotedFailure object:self];
        }
    }];
}

/*!
 Calculates the average scores for this pitch
 */
- (void)calculateScores {
    self.innovationScore = self.usefulnessScore = self.coolnessScore = self.overallScore = 0;

    for (KTPPitchVote *vote in self.votes) {
        self.innovationScore += vote.innovationScore;
        self.usefulnessScore += vote.usefulnessScore;
        self.coolnessScore += vote.coolnessScore;
    }
    
    self.innovationScore /= self.votes.count ? self.votes.count : 1;
    self.usefulnessScore /= self.votes.count ? self.votes.count : 1;
    self.coolnessScore /= self.votes.count ? self.votes.count : 1;
    self.overallScore = (self.innovationScore + self.usefulnessScore + self.coolnessScore) / 3;
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

/*!
 Returns a JSON object with all editable properties of a KTPPitch
 
 @returns       The JSON object as an NSDictionary
 */
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
             @"title"       :   self.pitchTitle,
             @"description" :   self.pitchDescription,
             @"votes"       :   votes
             };
}

#pragma mark - KVO

- (void)addObservers {
    [self addObserver:self forKeyPath:@"votes" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"votes"]) {
        NSLog(@"observed value");
        [self calculateScores];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"votes"];
}

@end
