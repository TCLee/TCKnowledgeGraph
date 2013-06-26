//
//  TCWikipediaClient.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/20/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/*
 AFHTTPClient subclass for Wikipedia API.
 */
@interface TCWikipediaClient : AFHTTPClient

+ (TCWikipediaClient *)sharedClient;

@end
