//
//  KTPRequirementsDataSource.h
//  KTP
//
//  Created by Greg Azevedo on 8/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KTPRequirementsGroup) {
    KTPRequirementsGroupCommunityService,
    KTPRequirementsGroupProfessionalDevelopment,
    KTPRequirementsGroupPledgeTasks,
    KTPRequirementsGroupCount
};

@interface KTPRequirementsDataSource : NSObject <UITableViewDataSource>

@end
