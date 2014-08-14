//
//  KTPRequirementsDataSource.m
//  KTP
//
//  Created by Greg Azevedo on 8/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPRequirementsDataSource.h"

@interface KTPRequirementsDataSource ()

@property (nonatomic) NSArray *allRequirements;
@property (nonatomic) NSArray *proDevItems;
@property (nonatomic) NSArray *pledgeTasks;
@property (nonatomic) NSArray *communityServiceHours;

@end

@implementation KTPRequirementsDataSource

- (id)init
{
    self = [super init];
    if (self) {
        self.proDevItems = @[@"1", @"2", @"3"];
        self.communityServiceHours = @[@"1", @"2", @"3"];
        self.pledgeTasks = @[@"1", @"2", @"3"];
        self.allRequirements = @[self.proDevItems, self.communityServiceHours, self.pledgeTasks];
    }
    return self;
}

#pragma mark - TABLE VIEW DATA SOURCE

#pragma mark REQUIRED METHODS

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *sectionItems = [self.allRequirements objectAtIndex:indexPath.section];
    NSString *itemText = [sectionItems objectAtIndex:indexPath.row];
    [cell.textLabel setText:itemText];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case KTPRequirementsGroupCommunityService:
            return self.communityServiceHours.count;
        case KTPRequirementsGroupPledgeTasks:
            return self.pledgeTasks.count;
        case KTPRequirementsGroupProfessionalDevelopment:
            return self.proDevItems.count;
        default:
            return 0;
    }
}

#pragma mark OPTIONAL METHODS

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KTPRequirementsGroupCount;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case KTPRequirementsGroupCommunityService:
            return @"Community Service";
        case KTPRequirementsGroupProfessionalDevelopment:
            return @"Professional Development";
        case KTPRequirementsGroupPledgeTasks:
            return @"Pledge Tasks";
        default:
            return @"unaccounted for";
    }
}


@end
