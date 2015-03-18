//
//  KTPPledgeTask.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeTask.h"
#import "KTPNetworking.h"

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

- (void)update:(void (^)(BOOL successful))block {
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePUT toRoute:KTPRequestRouteAPIPledgeTasks appending:self._id parameters:nil withJSONBody:[self JSONObject] block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPledgeTaskUpdateFailed object:self];
        }
        if (block) {
            block(!error);
        }
    }];
}

- (NSDictionary*)JSONObject {
    return @{
             @"title"           :   self.taskTitle,
             @"description"     :   self.taskDescription,
             @"proof"           :   self.proof,
             @"points"          :   [NSNumber numberWithFloat:self.points],
             @"points_earned"   :   [NSNumber numberWithFloat:self.pointsEarned],
             @"minimum_pledges" :   [NSNumber numberWithUnsignedInteger:self.minimumPledges],
             @"repeatable"      :   [NSNumber numberWithBool:self.repeatable]
             };
}

@end
