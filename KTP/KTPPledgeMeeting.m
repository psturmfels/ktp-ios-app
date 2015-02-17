//
//  KTPPledgeMeeting.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeMeeting.h"
#import "KTPNetworking.h"

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

#pragma mark - Update

- (void)update:(void (^)(BOOL successful))block {
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePUT toRoute:KTPRequestRouteAPIPledgeMeetings appending:self._id parameters:nil withBody:[self JSONObject] block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPledgeMeetingUpdateFailed object:self];
        }
        if (block) {
            block(!error);
        }
    }];
}

/*!
 Returns a JSON object with all editable properties of a KTPPledgeMeeting
 
 @returns       The JSON object as an NSDictionary
 */
- (NSDictionary*)JSONObject {
    return @{
             @"complete"            :   [NSNumber numberWithBool:self.complete]
             };
}

@end
