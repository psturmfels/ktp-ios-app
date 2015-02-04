//
//  KTPPitchesResultSortViewController.h
//  KTP
//
//  Created by Owen Yang on 2/3/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTPPitchesResultSortType) {
    KTPPitchesResultSortTypeInnovation,
    KTPPitchesResultSortTypeUsefulness,
    KTPPitchesResultSortTypeCoolness,
    KTPPitchesResultSortTypeOverall
};

@protocol KTPPitchesResultSortDelegate;

@interface KTPPitchesResultSortViewController : UIViewController
@property (nonatomic, assign) id<KTPPitchesResultSortDelegate> delegate;

- (instancetype)initWithSortType:(KTPPitchesResultSortType)sortType;
@end

@protocol KTPPitchesResultSortDelegate <NSObject>
@optional
- (void)pitchesResultSortViewControllerDidFinishWithSortType:(KTPPitchesResultSortType)sortType;
@end
