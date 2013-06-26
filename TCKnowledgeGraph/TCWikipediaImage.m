//
//  TCWikipediaImage.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/20/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCWikipediaImage.h"
#import "TCFreebaseClient.h"
#import "TCWikipediaClient.h"

@implementation TCWikipediaImage

- (id)initWithPageID:(NSString *)pageID attributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        NSDictionary *pageInfo = attributes[@"query"][@"pages"][pageID];
        NSDictionary *imageInfo = pageInfo[@"thumbnail"];
        
        _URLString = [imageInfo[@"source"] copy];
        _alternateText = [pageInfo[@"title"] copy];        
    }
    return self;
}

@end
