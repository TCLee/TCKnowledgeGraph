//
//  TCWikipediaImage.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/20/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@interface TCWikipediaImage : NSObject

@property (nonatomic, copy, readonly) NSString *URLString;
@property (nonatomic, copy, readonly) NSString *alternateText;

- (id)initWithPageID:(NSString *)pageID attributes:(NSDictionary *)attributes;

@end
