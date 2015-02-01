//
//  KTPSPitches.m
//  KTP
//
//  Created by Owen Yang on 2/1/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSPitches.h"
#import "KTPNetworking.h"
#import "KTPPitch.h"
#import "KTPPitchVote.h"
#import "KTPMember.h"

@implementation KTPSPitches

+ (KTPSPitches *)pitches {
    static KTPSPitches *pitches;
    static dispatch_once_t pitchesToken;
    dispatch_once(&pitchesToken, ^{
        pitches = [self new];
    });
    return pitches;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadPitches];
    }
    return self;
}

- (void)reloadPitches {
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypeGET toRoute:KTPRequestRouteAPIPitches appending:nil parameters:@"sort=title" withBody:nil block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSError *jsonError;
            NSArray *pitches = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                [self loadPitches:pitches];
            } else {
                NSLog(@"JSONSerialization Error:\n%@", jsonError.userInfo);
            }
        } else {
            NSLog(@"Pitches fetch failed with error:\n%@", error.userInfo);
        }
    }];
}

- (void)loadPitches:(NSArray*)pitches {
    self.pitchesArray = [NSMutableArray new];
    for (NSDictionary *pitchDict in pitches) {
        NSMutableArray *votesDict = pitchDict[@"votes"];
        NSMutableArray *votes = [NSMutableArray new];
        for (NSDictionary *vote in votesDict) {
            [votes addObject:[[KTPPitchVote alloc] initWithMember:[KTPMember memberWithID:vote[@"member"]]
                                                  innovationScore:[vote[@"innovationScore"] unsignedIntegerValue]
                                                  usefulnessScore:[vote[@"usefulnessScore"] unsignedIntegerValue]
                                                    coolnessScore:[vote[@"coolnessScore"] unsignedIntegerValue]]];
        }
        [self.pitchesArray addObject:[[KTPPitch alloc] initWithMember:[KTPMember memberWithID:pitchDict[@"member"]]
                                                                title:pitchDict[@"title"]
                                                          description:pitchDict[@"description"]
                                                                votes:votes
                                                                  _id:pitchDict[@"_id"]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPitchesUpdated object:self];
}

@end
