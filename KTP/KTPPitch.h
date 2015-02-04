//
//  KTPPitch.h
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KTPMember;
@class KTPPitchVote;

/*!
 @class         KTPPitch
 @description   The KTPPitch class represents a pitch for a KTP pitch contest.
 */
@interface KTPPitch : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) KTPMember *member;
@property (nonatomic, strong) NSString *pitchTitle;
@property (nonatomic, strong) NSString *pitchDescription;
@property (nonatomic, strong) NSMutableArray *votes;

@property (nonatomic) CGFloat innovationScore;
@property (nonatomic) CGFloat usefulnessScore;
@property (nonatomic) CGFloat coolnessScore;
@property (nonatomic) CGFloat overallScore;

- (instancetype)initWithMember:(KTPMember*)member title:(NSString*)title description:(NSString*)description votes:(NSMutableArray*)votes _id:(NSString*)_id;

/*!
 Returns whether the user has already voted on this pitch.
 
 @returns       YES if the user has already voted on this pitch, NO otherwise.
 */
- (BOOL)userDidVote;

/*!
 Adds a vote to this pitch and updates the database.
 
 @param         vote    The vote to add
 */
- (void)addVote:(KTPPitchVote*)vote;

@end
