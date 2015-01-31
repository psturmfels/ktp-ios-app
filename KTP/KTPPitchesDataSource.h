//
//  KTPPitchesDataSource.h
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPPitchesDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *pitchArray;   // type: KTPPitch

- (void)reloadPitches;

@end
