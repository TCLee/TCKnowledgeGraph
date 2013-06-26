//
//  TCWikipediaClient.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/20/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCWikipediaClient.h"

static NSString * const SERVICE_URL = @"http://en.wikipedia.org/w/api.php";

@implementation TCWikipediaClient

+ (TCWikipediaClient *)sharedClient {
    static TCWikipediaClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSURL alloc] initWithString:SERVICE_URL];
        _sharedClient = [[TCWikipediaClient alloc] initWithBaseURL:url];
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

@end
