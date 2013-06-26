//
//  TCFreebaseProperty.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/16/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCFreebaseProperty.h"
#import "TCFreebaseDataType.h"

// Freebase uses ISO8601 for their date time formats.
#import "ISO8601DateFormatter.h"

@interface TCFreebaseProperty ()

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray *mutableValues;

@end

@implementation TCFreebaseProperty

- (id)initWithID:(NSString *)propertyID name:(NSString *)propertyName
{
    self = [super init];
    if (self) {
        _ID = [propertyID copy];
        _name = [propertyName copy];
    }
    return self;
}

- (NSArray *)values
{
    return [self.mutableValues copy];
}

- (void)parseProperty:(NSDictionary *)propertyDict
{
    self.type = propertyDict[@"valuetype"];
    
    NSArray *values = propertyDict[@"values"];
    self.mutableValues = [[NSMutableArray alloc] initWithCapacity:[values count]];
        
    for (NSDictionary *value in values) {
        // Ignore compound value types to limit the data to display.
        if ([self.type isEqualToString:FreebaseTypeCompound]) {
            continue;
        }
        
        // Get the textual representation of the property value.
        NSString *textValue = value[@"text"];
        
        // Format Freebase's date time string to make it more human-friendly.
        if ([self.type isEqualToString:FreebaseTypeDateTime]) {
            textValue = [self prettyDateString:textValue];
        }
        
        [self.mutableValues addObject:textValue];
    }
}

/* Returns a human-friendly version of Freebase's date time string. */
- (NSString *)prettyDateString:(NSString *)freebaseDateString
{
    ISO8601DateFormatter *freebaseDateFormatter = [[ISO8601DateFormatter alloc] init];
    NSDate *date = [freebaseDateFormatter dateFromString:freebaseDateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    return [dateFormatter stringFromDate:date];
}

@end
