//
//  KTPPitchesDataSource.m
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchesDataSource.h"
#import "KTPNetworking.h"
#import "KTPPitch.h"
#import "KTPSMembers.h"
#import "KTPMember.h"
#import "KTPPitchVote.h"

@implementation KTPPitchesDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadPitches];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchCell" forIndexPath:indexPath];
    
    KTPPitch *pitch = self.pitchArray[indexPath.row];
    cell.textLabel.text = pitch.pitchTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", pitch.member.firstName, pitch.member.lastName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pitchArray.count;
}

- (void)reloadPitches {
    self.pitchArray = [NSMutableArray new];
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypeGET toRoute:KTPRequestRouteAPIPitches appending:nil parameters:nil withBody:nil block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSError *jsonError;
            NSArray *pitches = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                [self loadPitches:pitches];
            } else {
                NSLog(@"JSONSerialization Error: %@", jsonError.userInfo);
            }
        } else {
            NSLog(@"Error loading pitches: %@", error.userInfo);
        }
    }];
}

- (void)loadPitches:(NSArray*)pitches {
    for (NSDictionary *pitch in pitches) {
        NSMutableArray *votesDict = pitch[@"votes"];
        NSMutableArray *votes;
        for (NSDictionary *vote in votesDict) {
            [votes addObject:[[KTPPitchVote alloc] initWithMember:[KTPMember memberWithID:vote[@"_id"]]
                                                  innovationScore:[vote[@"innovationScore"] unsignedIntegerValue]
                                                  usefulnessScore:[vote[@"usefulnessScore"] unsignedIntegerValue]
                                                    coolnessScore:[vote[@"coolnessScore"] unsignedIntegerValue]]];
        }
        [self.pitchArray addObject:[[KTPPitch alloc] initWithMember:[KTPMember memberWithID:pitch[@"member"]]
                                                              title:pitch[@"title"]
                                                        description:pitch[@"description"]
                                                              votes:votes]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationPitchesUpdated object:self];
}

@end
