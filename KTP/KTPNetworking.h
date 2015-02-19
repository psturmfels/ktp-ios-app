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
    KTPRequestRouteAPIChangePassword,   /*  /api/changePassword/    */
    KTPRequestRouteAPIPitches,          /*  /api/pitches/           */
    KTPRequestRouteAPIPledgeTasks,      /*  /api/pledgeTasks/       */
    KTPRequestRouteAPIPledgeMeetings,   /*  /api/pledgeMeetings/    */
    KTPRequestRouteAPICommittees        /*  /api/committees/        */
};

typedef NS_ENUM(NSInteger, KTPContentType) {
    KTPContentTypeJSON,                 /*  application/json        */
    KTPContentTypePNG                   /*  image/png               */
};

/*!
 @class         KTPNetworking
 @description   The KTPNetworking class handles all network interaction with the KTP API and database.
 */
@interface KTPNetworking : NSObject

/*!
 Sends an asynchronous NSURLRequest of the specified KTPRequestType to the specified API route/append with parameters. Body should be a JSON object. The response parameters are forwarded by calling block.
 
 @param         type        The type of request
 @param         route       The route to send the request to
 @param         append      A string to append to the route
 @param         parameters  Any parameters to the request (separated by '&')
 @param         body        The body of the request in JSON dictionary format
 @param         block       Block to forward response to
 */
+ (void)sendAsynchronousRequestType:(KTPRequestType)type
                            toRoute:(KTPRequestRoute)route
                          appending:(NSString*)append
                         parameters:(NSString*)parameters
                       withJSONBody:(NSDictionary*)body
                              block:(void (^)(NSURLResponse *response, NSData *data, NSError *error))block;

/*!
 Sends an asynchronous NSURLRequest of the specified KTPRequestType to the specified API route/append with parameters. The response parameters are forwarded by calling block.
 
 @param         type        The type of request
 @param         route       The route to send the request to
 @param         append      A string to append to the route
 @param         parameters  Any parameters to the request (separated by '&')
 @param         data        The data of the request
 @param         contentType The content type of the data
 @param         block       Block to forward response to
 */
+ (void)sendAsynchronousRequestType:(KTPRequestType)requestType
                            toRoute:(KTPRequestRoute)route
                          appending:(NSString*)append
                         parameters:(NSString*)parameters
                           withData:(NSData *)data
                        contentType:(KTPContentType)contentType
                              block:(void (^)(NSURLResponse *, NSData *, NSError *))block;


@end
