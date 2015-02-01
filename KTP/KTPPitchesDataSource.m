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
#import "KTPSPitches.h"

@implementation KTPPitchesDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchCell" forIndexPath:indexPath];
    
    KTPPitch *pitch = [KTPSPitches pitches].pitchesArray[indexPath.row];
    cell.textLabel.text = pitch.pitchTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", pitch.member.firstName, pitch.member.lastName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [KTPSPitches pitches].pitchesArray.count;
}

@end
