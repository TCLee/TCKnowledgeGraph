//
//  TCSearchSuggestionCell.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCSearchSuggestionCell.h"

@implementation TCSearchSuggestionCell

- (void)awakeFromNib
{
    // Custom Font
    self.textLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.0];
    self.detailTextLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    
    // Custom Accessory View
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator"]
                                           highlightedImage:[UIImage imageNamed:@"Disclosure-Indicator-Highlighted"]];
}

@end
