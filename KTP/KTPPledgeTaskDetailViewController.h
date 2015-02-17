//
//  KTPPledgeTaskDetailViewController.h
//  KTP
//
//  Created by Patrick Wilson on 2/16/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPPledgeTask;

@interface KTPPledgeTaskDetailViewController : UIViewController

@property (nonatomic, strong) KTPPledgeTask *pledgeTask;


/*!
 Initializes this class with a KTPMember.
 
 @param         member
 @returns       A KTPProfileViewController object
 */
- (instancetype)initWithPledgeTask:(KTPPledgeTask*)pledgeTask;

@end
