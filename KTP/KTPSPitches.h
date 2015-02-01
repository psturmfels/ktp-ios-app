//
//  KTPSPitches.h
//  KTP
//
//  Created by Owen Yang on 2/1/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class         KTPSPitches
 @description   The KTPSPitches class is a singleton that handles fetching and maintaining the information of all pitches.
 */
@interface KTPSPitches : NSObject

@property (nonatomic, strong) NSMutableArray *pitchesArray; // type: KTPPitch

/*!
 This method is used to access the singleton instance of KTPSPitches.
 
 @returns       The singleton instance of KTPSPitches
 */
+ (KTPSPitches *)pitches;

/*!
 Sends a request to the KTP API for new pitches data and loads pitchesArray when request is complete.
 */
- (void)reloadPitches;

@end
