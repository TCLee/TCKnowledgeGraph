//
//  TCFreebaseClient.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/*
 AFHTTPClient subclass for Freebase API.
 */
@interface TCFreebaseClient : AFHTTPClient

+ (TCFreebaseClient *)sharedClient;

@end
