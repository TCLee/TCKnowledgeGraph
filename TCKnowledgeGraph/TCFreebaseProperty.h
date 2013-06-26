//
//  TCFreebaseProperty.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/16/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 This model class represents a property in the Freebase knowledge graph.
 */
@interface TCFreebaseProperty : NSObject

@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *type;

- (id)initWithID:(NSString *)propertyID name:(NSString *)propertyName;

- (void)parseProperty:(NSDictionary *)propertyDict;

/* A property can have zero or more values associated with it. */
- (NSArray *)values;

@end
