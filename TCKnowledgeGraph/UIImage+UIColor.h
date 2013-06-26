//
//  UIImage+UIColor.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIColor)

/*
 Creates and returns a 1x1 px image of given solid color.
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
