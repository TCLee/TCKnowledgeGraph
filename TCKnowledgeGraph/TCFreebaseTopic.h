//
//  TCFreebaseTopic.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/16/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/*
 This model class represents a Topic in the Freebase knowledge graph.
 */
@interface TCFreebaseTopic : NSObject

@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *imageURLString;
@property (nonatomic, copy, readonly) NSString *imageAlternateText;
@property (nonatomic, copy, readonly) NSString *description;

- (id)initWithID:(NSString *)topicID name:(NSString *)topicName;

- (void)getTopicWithCompletionHandler:(void (^)())completionHandler;

- (void)cancel;

/*
 Returns an array of notable properties for this Freebase Topic. 
 Each topic will have its own notable properties.
 */
- (NSArray *)notableProperties;

@end
