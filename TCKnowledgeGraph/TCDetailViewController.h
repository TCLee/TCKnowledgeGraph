//
//  TCDetailViewController.h
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/12/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCFreebaseTopic;

@interface TCDetailViewController : UIViewController
    <UIGestureRecognizerDelegate>

@property (nonatomic, strong) TCFreebaseTopic *topic;

@end
