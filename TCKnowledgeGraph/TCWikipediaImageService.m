//
//  TCWikipediaImageService.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/21/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCWikipediaImageService.h"
#import "TCWikipediaImage.h"
#import "TCFreebaseClient.h"
#import "TCWikipediaClient.h"

@interface TCWikipediaImageService ()

/* We need to store strong references to the HTTP request operation objects, so that we 
   can cancel them at anytime. */
@property (nonatomic, strong) AFHTTPRequestOperation *freebaseOperation;
@property (nonatomic, strong) AFHTTPRequestOperation *wikipediaOperation;

@end

@implementation TCWikipediaImageService

+ (TCWikipediaImageService *)sharedService
{
    static TCWikipediaImageService *_sharedService = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedService = [[TCWikipediaImageService alloc] init];
    });
    
    return _sharedService;
}

/* Cancels any ongoing Freebase and Wikipedia API requests. */
- (void)cancel
{
    [self.freebaseOperation cancel];
    self.freebaseOperation = nil;
    
    [self.wikipediaOperation cancel];
    self.wikipediaOperation = nil;
}

#pragma mark - Get Image URL from Wikipedia

- (void)imageForFreebaseTopicID:(NSString *)topicID
              completionHandler:(void (^)(TCWikipediaImage *image))completionHandler
{
    // Find the corresponding Wikipedia page ID for given Freebase Topic.
    [self wikipediaPageIDForFreebaseTopicID:topicID completionHandler:^(NSString *wikipediaPageID) {
        if (wikipediaPageID) {
            // Now that we've got the Wikipedia page ID, we can try to get the image from the Wikipedia page.
            [self imageWithWikipediaPageID:wikipediaPageID completionHandler:^(TCWikipediaImage *image) {
                completionHandler(image);
            }];
        } else {
            // No corresponding Wikipedia page ID found. That means no image too. :-(
            completionHandler(nil);
        }
    }];
}

/* Finds the Freebase Topic's corresponding Wikipedia's page ID (if available). */
- (void)wikipediaPageIDForFreebaseTopicID:(NSString *)topicID completionHandler:(void (^)(NSString *wikipediaPageID))completionHandler
{
    NSParameterAssert(completionHandler);
    
    TCFreebaseClient *freebaseClient = [TCFreebaseClient sharedClient];
    
    // MQL to find the corresponding Wikipedia page ID for the given topic.
    // MQL uses the JSON syntax.
    id query = @{@"id": topicID,
                 @"key": @{@"namespace": @"/wikipedia/en_id",
                           @"value": [NSNull null]},
                 @"limit": @1};
    
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:query options:0 error:NULL];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    NSURLRequest *request = [freebaseClient requestWithMethod:@"GET" path:@"mqlread" parameters:@{@"query": JSONString}];
    
    self.freebaseOperation = [freebaseClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result = responseObject[@"result"];
        
        // If result is NSNull (not nil), it means there's no Wikipedia page that
        // corresponds to the Freebase Topic.
        if ([NSNull null] == result) {
            completionHandler(nil);
        } else {
            NSString *wikipediaPageID = result[@"key"][@"value"];
            completionHandler(wikipediaPageID);
        }                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation isCancelled]) {
            NSLog(@"Fetch Wikipedia Page ID for Topic ID \"%@\" has been cancelled.", topicID);
        } else {
            NSLog(@"Fetch Wikipedia Page ID for Topic ID \"%@\" failed. Error:%@", topicID, [error localizedDescription]);
        }
        completionHandler(nil);
    }];
    
    [freebaseClient enqueueHTTPRequestOperation:self.freebaseOperation];
}

/* Gets the Wikipedia page's image. */
- (void)imageWithWikipediaPageID:(NSString *)pageID completionHandler:(void (^)(TCWikipediaImage *image))completionHandler
{
    NSParameterAssert(completionHandler);
    
    TCWikipediaClient *wikipediaClient = [TCWikipediaClient sharedClient];
    
    NSDictionary *parameters = @{@"format": @"json",
                                 @"action": @"query",
                                 @"pageids": pageID,
                                 @"prop": @"pageimages",
                                 @"piprop": @"thumbnail",
                                 @"pithumbsize": @300};
    NSURLRequest *request = [wikipediaClient requestWithMethod:@"GET" path:@"" parameters:parameters];
    
    self.wikipediaOperation = [wikipediaClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TCWikipediaImage *image = [[TCWikipediaImage alloc] initWithPageID:pageID attributes:responseObject];
        completionHandler(image);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation isCancelled]) {
            NSLog(@"Fetch Wikipedia image URL for page ID \"%@\" has been cancelled.", pageID);
        } else {
            NSLog(@"Wikipedia API Error: %@", [error localizedDescription]);
        }
        completionHandler(nil);
    }];
    
    [wikipediaClient enqueueHTTPRequestOperation:self.wikipediaOperation];
}

@end
