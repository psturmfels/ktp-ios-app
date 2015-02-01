//
//  KTPSPitches.h
//  KTP
//
//  Created by Owen Yang on 2/1/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPSPitches : NSObject

@property (nonatomic, strong) NSMutableArray *pitchesArray; // type: KTPPitch

+ (KTPSPitches *)pitches;

- (void)reloadPitches;

@end
