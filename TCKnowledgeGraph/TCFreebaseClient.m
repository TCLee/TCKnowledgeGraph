//
//  TCFreebaseClient.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCFreebaseClient.h"

/* 
 You can register for an API key at https://code.google.com/apis/console‎
 Google allows for a limit of 100,000 requests/day.
 */
static NSString * const API_KEY = @"AIzaSyBbsocrvsnfJPPC7Um7eY67hPUAYVsp41Y";
static NSString * const SERVICE_URL = @"https://www.googleapis.com/freebase/v1/";

@implementation TCFreebaseClient

+ (TCFreebaseClient *)sharedClient
{
    static TCFreebaseClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSURL alloc] initWithString:SERVICE_URL];
        _sharedClient = [[TCFreebaseClient alloc] initWithBaseURL:url];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

/* Automatically append the API key as a parameter. */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    if (!mutableParameters) {
        mutableParameters = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    // Automatically add the API key as a parameter, so we don't have to repeat
    // this parameter everywhere.
    mutableParameters[@"key"] = API_KEY;
    
    // Set pretty print to false to reduce the response payload size.
    mutableParameters[@"prettyPrint"] = @"false";
    
    parameters = [mutableParameters copy];
    
    return [super requestWithMethod:method path:path parameters:parameters];
}

@end
