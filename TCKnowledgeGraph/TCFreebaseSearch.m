//
//  TCFreebaseSearch.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/19/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCFreebaseSearch.h"
#import "TCFreebaseClient.h"

@implementation TCFreebaseSearchResult

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        _topicID = [attributes[@"mid"] copy];
        _topicName = [attributes[@"name"] copy];
        _notableName = [attributes[@"notable"][@"name"] copy];
    }
    return self;
}

@end

#pragma mark -

@interface TCFreebaseSearchService ()

// Keep a strong reference to the HTTP Request operation, so that we can cancel it later.
@property (nonatomic, strong) AFHTTPRequestOperation *searchOperation;

@end

@implementation TCFreebaseSearchService

+ (TCFreebaseSearchService *)sharedService
{
    static TCFreebaseSearchService *_sharedService = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedService = [[TCFreebaseSearchService alloc] init];
    });
    
    return _sharedService;
}

- (void)searchForQuery:(NSString *)query completionHandler:(void (^)(NSArray *))completionHandler
{
    // Before performing a new search, cancel any existing searches first.
    // Otherwise, we will be hitting the Freebase API every time for each character typed.
    if (self.searchOperation) {
        [self.searchOperation cancel];
    }

    TCFreebaseClient *freebaseClient = [TCFreebaseClient sharedClient];
    
    // Parameters for the Freebase Search API.
    NSDictionary *parameters = @{@"query": query,
                                 @"limit": @10,
                                 @"prefixed": @"true",
                                 @"type": @"/common/topic"};
    NSURLRequest *request = [freebaseClient requestWithMethod:@"GET" path:@"search" parameters:parameters];
    
    // Create the search operation and add it to the queue.
    self.searchOperation = [freebaseClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {        
        if (completionHandler) {
            completionHandler(searchResultsFromJSONObject(responseObject));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation isCancelled]) {
            NSLog(@"Search operation cancelled for query \"%@\"", query);
        } else {
            NSLog(@"Search API Error: %@", [error localizedDescription]);
        }
    }];
    
    [freebaseClient enqueueHTTPRequestOperation:self.searchOperation];
}

/* Map the JSON results to a TCFreebaseSearchResult object. */
NSArray* searchResultsFromJSONObject(NSDictionary *JSONObject)
{
    NSArray *resultsArray = JSONObject[@"result"];
    NSMutableArray *searchResults = [[NSMutableArray alloc] initWithCapacity:resultsArray.count];
    
    for (NSDictionary *resultObject in resultsArray) {
        TCFreebaseSearchResult *searchResult = [[TCFreebaseSearchResult alloc] initWithAttributes:resultObject];
        [searchResults addObject:searchResult];
    }
    
    return [searchResults copy];
}

@end

