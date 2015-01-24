//
//  KTPMembersDataSource.m
//  KTP
//
//  Created by Owen Yang on 1/20/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPMembersDataSource.h"
#import "KTPMembersCell.h"

#import "KTPSMembers.h"
#import "KTPMember.h"

@implementation KTPMembersDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [KTPSMembers members].membersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[KTPMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberCell"];
    }
    
    cell.member = [KTPSMembers members].membersArray[indexPath.row];
    
    return cell;
}

@end
