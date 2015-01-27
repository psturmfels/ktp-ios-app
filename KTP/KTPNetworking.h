//
//  KTPNetworking.h
//  KTP
//
//  Created by Owen Yang on 1/27/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KTPRequestType) {
    KTPRequestTypePOST,     // create
    KTPRequestTypeGET,      // read
    KTPRequestTypePUT,      // update
    KTPRequestTypeDELETE    // delete
};

typedef NS_ENUM(NSInteger, KTPRequestRoute) {
    KTPRequestRouteAPIMembers,          /*  /api/members/           */
    KTPRequestRouteAPILogin,            /*  /api/login/             */
    KTPRequestRouteAPIChangePassword    /*  /api/changePassword/    */
};

/*!
 @class         KTPNetworking
 @description   The KTPNetworking class handles all network interaction with the KTP API and database.
 */
@interface KTPNetworking : NSObject

/*!
 Sends an asynchronous NSURLRequest of the specified KTPRequestType to the specified API route/append with parameters. Body should be a JSON object. The response parameters are forwarded by calling block.
 
 @param         type
 @param         route
 @param         append
 @param         parameters
 @param         body
 @param         block
 */
+ (void)sendAsynchronousRequestType:(KTPRequestType)type
                            toRoute:(KTPRequestRoute)route
                          appending:(NSString*)append
                         parameters:(NSString*)parameters
                           withBody:(NSDictionary*)body
                              block:(void (^)(NSURLResponse *response, NSData *data, NSError *error))block;

@end
