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

@property (nonatomic, strong) KTPMember *member;
@property (nonatomic, strong) NSString *pitchTitle;
@property (nonatomic, strong) NSString *pitchDescription;
@property (nonatomic, strong) NSMutableArray *votes;

- (instancetype)initWithMember:(KTPMember*)member;
- (instancetype)initWithMember:(KTPMember*)member title:(NSString*)title description:(NSString*)description votes:(NSMutableArray*)votes;

- (void)addVote:(KTPPitchVote*)vote;

- (NSDictionary*)JSONObject;

@end
