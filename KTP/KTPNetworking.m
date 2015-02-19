//
//  KTPNetworking.m
//  KTP
//
//  Created by Owen Yang on 1/27/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPNetworking.h"

NSString *const KTP_API_TOKEN = @"5af9a24515589a73d0fa687e69cbaaa15918f833";

@implementation KTPNetworking

+ (NSString*)requestTypeToString:(KTPRequestType)type {
    switch (type) {
        case KTPRequestTypePOST:
            return @"POST";
        case KTPRequestTypeGET:
            return @"GET";
        case KTPRequestTypePUT:
            return @"PUT";
        case KTPRequestTypeDELETE:
            return @"DELETE";
    }
}

+ (NSString*)requestRouteToString:(KTPRequestRoute)route {
    switch (route) {
        case KTPRequestRouteAPIMembers:
            return @"/api/members/";
        case KTPRequestRouteAPILogin:
            return @"/api/login/";
        case KTPRequestRouteAPIChangePassword:
            return @"/api/changePassword/";
        case KTPRequestRouteAPIPitches:
            return @"/api/pitches/";
        case KTPRequestRouteAPIPledgeTasks:
            return @"/api/pledgeTasks/";
        case KTPRequestRouteAPIPledgeMeetings:
            return @"/api/pledgeMeetings/";
        case KTPRequestRouteAPICommittees:
            return @"/api/committees/";
    }
}

+ (NSString*)contentTypeToString:(KTPContentType)type {
    switch (type) {
        case KTPContentTypeJSON:
            return @"application/json";
        case KTPContentTypePNG:
            return @"image/png";
    }
}

+ (void)sendAsynchronousRequestType:(KTPRequestType)type
                            toRoute:(KTPRequestRoute)route
                          appending:(NSString*)append
                         parameters:(NSString*)parameters
                       withJSONBody:(NSDictionary *)body
                              block:(void (^)(NSURLResponse *, NSData *, NSError *))block
{
    NSData *data;
    NSError *error;
    if (body) {
        data = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    }
    
    if (!error) {
        [KTPNetworking sendAsynchronousRequestType:type toRoute:route appending:append parameters:parameters withData:data contentType:KTPContentTypeJSON block:block];
    } else {
        NSLog(@"JSON Serialization Failed");
        block(nil, nil, error);
    }
}

+ (void)sendAsynchronousRequestType:(KTPRequestType)requestType
                            toRoute:(KTPRequestRoute)route
                          appending:(NSString*)append
                         parameters:(NSString*)parameters
                           withData:(NSData *)data
                        contentType:(KTPContentType)contentType
                              block:(void (^)(NSURLResponse *, NSData *, NSError *))block
{
    NSString *requestTypeString = [KTPNetworking requestTypeToString:requestType];
    NSString *requestRouteString = [KTPNetworking requestRouteToString:route];
    NSString *contentTypeString = [KTPNetworking contentTypeToString:contentType];
    NSMutableString *requestURLString = [NSMutableString stringWithFormat:@"http://kappathetapi.com%@", requestRouteString];
    if (append) {
        [requestURLString appendString:append];
    }
    if (parameters) {
        [requestURLString appendFormat:@"?%@", parameters];
    }
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    request.allHTTPHeaderFields = @{@"x-access-token"   : KTP_API_TOKEN,
                                    @"Content-Type"     : contentTypeString};
    request.HTTPMethod = requestTypeString;
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        block(response, data, connectionError);
    }];
}

@end
