//
//  KTPSPledgeTasks.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSPledgeTasks.h"
#import "KTPPledgeTask.h"
#import "KTPNetworking.h"
#import "KTPMember.h"

@implementation KTPSPledgeTasks

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadPledgeTasks];
    }
    return self;
}

+ (KTPSPledgeTasks *)pledgeTasks {
    static KTPSPledgeTasks *pledgeTasks;
    static dispatch_once_t pledgeTasksToken;
    dispatch_once(&pledgeTasksToken, ^{
        pledgeTasks = [self new];
    });
    return pledgeTasks;
}

- (void)reloadPledgeTasks {
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypeGET toRoute:KTPRequestRouteAPIPledgeTasks appending:nil parameters:@"sort=-points" withBody:nil block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPledgeTasksUpdateFailed object:self];
        } else {
            NSError *error;
            NSArray *pledgeTasks = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPledgeTasksUpdateFailed object:self];
            } else {
                [self loadPledgeTasks:pledgeTasks];
            }
        }
    }];
}

- (void)loadPledgeTasks:(NSArray*)pledgeTasks {
    self.pledgeTasksArray = [NSMutableArray new];
    for (NSDictionary *pledgeTask in pledgeTasks) {
        NSMutableArray *pledges = pledgeTask[@"pledges"];
        for (int i = 0; i < pledges.count; ++i) {
            pledges[i] = [KTPMember memberWithID:pledges[i]];
        }
        [self.pledgeTasksArray addObject:[[KTPPledgeTask alloc] initWithTitle:pledgeTask[@"title"]
                                                                  description:pledgeTask[@"description"]
                                                                        proof:pledgeTask[@"proof"]
                                                                       points:[pledgeTask[@"points"] floatValue]
                                                                 pointsEarned:[pledgeTask[@"points_earned"] floatValue]
                                                               minimumPledges:[pledgeTask[@"minimum_pledges"] unsignedIntegerValue]
                                                                   repeatable:[pledgeTask[@"repeatable"] boolValue]
                                                                      pledges:pledges
                                                                          _id:pledgeTask[@"_id"]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPledgeTasksUpdated object:self];
}

@end
