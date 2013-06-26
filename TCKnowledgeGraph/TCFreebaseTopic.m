//
//  TCFreebaseTopic.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/16/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCFreebaseTopic.h"
#import "TCFreebaseClient.h"
#import "TCFreebaseProperty.h"
#import "TCWikipediaImage.h"
#import "TCWikipediaImageService.h"

/* URL to Freebase's Image API. */
static NSString * const FreebaseImageAPIFormat = @"https://usercontent.googleapis.com/freebase/v1/image%@?maxwidth=%lu";
static NSUInteger const ImageMaxWidth = 250;

@interface TCFreebaseTopic ()

@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, copy) NSString *imageAlternateText;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) AFHTTPRequestOperation *topicOperation;
@property (nonatomic, strong) NSMutableArray *mutableNotableProperties;

@end

@implementation TCFreebaseTopic

- (id)initWithID:(NSString *)topicID name:(NSString *)topicName
{
    self = [super init];
    if (self) {
        _ID = [topicID copy];
        _name = [topicName copy];
    }
    return self;
}

- (NSArray *)notableProperties
{
    return [self.mutableNotableProperties copy];
}

#pragma mark -

- (void)getTopicWithCompletionHandler:(void (^)())completionHandler
{
    NSParameterAssert(completionHandler);
    
    TCFreebaseClient *freebaseClient = [TCFreebaseClient sharedClient];
    
    // Append the Topic ID to the topic path.
    NSString *topicPath = [@"topic" stringByAppendingPathComponent:self.ID];    
    
    // Limit the number of properties returned about a topic to save on network bandwidth.
    // Use a NSSet instead of a NSArray to prevent AFNetworking from adding "[]" to our
    // parameter keys.
    NSSet *filters = [[NSSet alloc] initWithArray:@[
                      @"/common/topic/description",
                      @"/common/topic/image",
                      @"/common/topic/notable_properties"]];
    NSDictionary *parameters = @{@"filter": filters};
    NSURLRequest *request = [freebaseClient requestWithMethod:@"GET" path:topicPath parameters:parameters];
  
    self.topicOperation = [freebaseClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse the Topic object's properties from the response data.
        [self parseTopicProperties:responseObject[@"property"]];
        
        // If Freebase Topic has an image associated with it, we will just use that image.
        // Otherwise, we will attempt to get the image from the corresponding Wikipedia page.
        if (self.imageURLString) {
            completionHandler();
        } else {
            [[TCWikipediaImageService sharedService] imageForFreebaseTopicID:self.ID completionHandler:^(TCWikipediaImage *image) {
                self.imageURLString = image.URLString;
                self.imageAlternateText = image.alternateText;
                completionHandler();
            }];            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation isCancelled]) {
            NSLog(@"Topic GET operation has been cancelled. Topic: %@", self.name);
        } else {
            NSLog(@"Topic API Error: %@", [error localizedDescription]);
        }
        completionHandler();
    }];
    
    [freebaseClient enqueueHTTPRequestOperation:self.topicOperation];
}


/* Cancels any existing Topic GET operation. If no existing GET operation then this
   method does nothing. */
- (void)cancel
{
    // Also cancels any ongoing Wikipedia API requests.
    [[TCWikipediaImageService sharedService] cancel];
    
    [self.topicOperation cancel];
}

#pragma mark - Parse Topic JSON

- (void)parseTopicProperties:(NSDictionary *)properties
{
    [self parseImageURL:properties];    
    [self parseDescription:properties];

    // Parse the notable properties of a topic.
    [self parseNotableProperties:properties];
}

- (void)parseImageURL:(NSDictionary *)topicProperties
{
    NSDictionary *imageProperty = topicProperties[@"/common/topic/image"];
    
    // Some Freebase Topics have no images associated with them.
    if (imageProperty) {
        // If there are more than one image, we'll just use the first image.
        NSArray *images = imageProperty[@"values"];
        NSDictionary *firstImage = images[0];
        
        NSString *imageID = firstImage[@"id"];
        self.imageURLString = [[NSString alloc] initWithFormat:FreebaseImageAPIFormat, imageID, (unsigned long)ImageMaxWidth];
        self.imageAlternateText = firstImage[@"text"];
    }
}

- (void)parseDescription:(NSDictionary *)topicProperties
{
    NSArray *values = topicProperties[@"/common/topic/description"][@"values"];
    for (NSDictionary *value in values) {
        // We only want description with an actual citation (e.g. Wikipedia).
        if (value[@"citation"]) {
            self.description = value[@"value"];
            return;
        }
    }
}

- (void)parseNotableProperties:(NSDictionary *)topicProperties
{
    NSArray *values = topicProperties[@"/common/topic/notable_properties"][@"values"];
    
    self.mutableNotableProperties = [[NSMutableArray alloc] initWithCapacity:[values count]];
    NSMutableSet *propertyIdSet = [[NSMutableSet alloc] initWithCapacity:[values count]];
    
    for (NSDictionary *notableProperty in values) {
        NSString *propertyID = notableProperty[@"id"];
        NSString *propertyName = notableProperty[@"text"];
        
        // If the property ID already exists, don't add property again.
        // Freebase contains duplicate properties for some topics. We'll have to sanitize
        // the properties ourselves.
        if (![propertyIdSet containsObject:propertyID]) {
            [propertyIdSet addObject:propertyID];
            
            // Parse the property and add it to the array.
            TCFreebaseProperty *property = [[TCFreebaseProperty alloc] initWithID:propertyID name:propertyName];
            [property parseProperty:topicProperties[propertyID]];

            // Only add property if it has valid values.
            if (property.values.count > 0) {
                [self.mutableNotableProperties addObject:property];
            }
        }
    }
}

@end
