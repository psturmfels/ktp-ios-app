//
//  KTPSettingsDataSource.m
//  KTP
//
//  Created by Owen Yang on 2/2/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSettingsDataSource.h"

@implementation KTPSettingsDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Change Password";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
}

@end
