//
//  KTPSlideMenuDataSource.m
//  KTP
//
//  Created by Owen Yang on 1/20/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSlideMenuDataSource.h"
#import "KTPSlideMenuCell.h"

@interface KTPSlideMenuDataSource ()

@end

@implementation KTPSlideMenuDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPSlideMenuCell *cell = [KTPSlideMenuCell new];
    
    NSString *cellTitle;
    KTPViewType cellViewType;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cellTitle = @"Members";
                cellViewType = KTPViewTypeMembers;
                break;
            case 1:
                cellTitle = @"Pledge";
                cellViewType = KTPViewTypePledge;
                break;
            case 2:
                cellTitle = @"Announcements";
                cellViewType = KTPViewTypeAnnouncements;
                break;
            case 3:
                cellTitle = @"Pitches";
                cellViewType = KTPViewTypePitches;
                break;
            case 4:
                cellTitle = @"Settings";
                cellViewType = KTPViewTypeSettings;
                break;
            default:
                break;
        }
        cell.textLabel.text = cellTitle;
        cell.viewType = cellViewType;
    }
    return cell;
}

@end
