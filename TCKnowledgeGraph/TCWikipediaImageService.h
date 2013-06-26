//
//  TCWikipediaImageService.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/21/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@class TCWikipediaImage;

@interface TCWikipediaImageService : NSObject

+ (TCWikipediaImageService *)sharedService;

/*
 Gets the Wikipedia image for the given Freebase Topic. A lot of the Freebase Topic
 are missing images, so we have to rely on good old Wikipedia for the images.
 */
- (void)imageForFreebaseTopicID:(NSString *)topicID
              completionHandler:(void (^)(TCWikipediaImage *image))completionHandler;

/* Cancels all the operations that relate to fetching the image URL from Wikipedia. */
- (void)cancel;

@end
