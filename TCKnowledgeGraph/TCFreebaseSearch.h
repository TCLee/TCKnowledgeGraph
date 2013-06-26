//
//  TCFreebaseSearch.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/19/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/*
 Encapsulates the Freebase search results JSON response.
 */
@interface TCFreebaseSearchResult : NSObject
@property (nonatomic, copy, readonly) NSString *topicID;
@property (nonatomic, copy, readonly) NSString *topicName;
@property (nonatomic, copy, readonly) NSString *notableName;
@end

//TODO: Separate TCFreebaseSearchService to another class and place it under Services group?

/*
 Provides a simple method to fetch suggestions from Freebase Search API.
 */
@interface TCFreebaseSearchService : NSObject

+ (TCFreebaseSearchService *)sharedService;

- (void)searchForQuery:(NSString *)query
     completionHandler:(void (^)(NSArray *searchResults))completionHandler;
@end