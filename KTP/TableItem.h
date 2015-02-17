//
//  TableItem.h
//  sampletable
//
//  Created by Greg Azevedo on 2/16/15.
//  Copyright (c) 2015 gregazevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableItem : NSObject

@property (nonatomic) NSString *placeholder;
@property (nonatomic) NSString *text;
@property (nonatomic) NSIndexPath *indexPath;

@end
