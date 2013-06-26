//
//  UIImage+UIColor.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "UIImage+UIColor.h"

@implementation UIImage (UIColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 60.0);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
