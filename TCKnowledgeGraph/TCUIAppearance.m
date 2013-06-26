//
//  TCUIAppearance.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCUIAppearance.h"
#import "UIImage+UIColor.h"

@implementation TCUIAppearance

+ (void)styleApp
{
    [self styleNavigationBar]; 
    [self styleBackButton];
    [self styleSearchBar];
}

#pragma mark - UINavigationBar, UIBarButtonItem Themes

+ (void)styleNavigationBar
{
    UIImage *flatColorImage = [UIImage imageWithColor:[UIColor blackColor]];
    
    // Customize the navigation bar's background image.
    [[UINavigationBar appearance] setBackgroundImage:flatColorImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:flatColorImage forBarMetrics:UIBarMetricsLandscapePhone];
    
    // Remove shadow from the navigation bar by giving it an empty image.
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

+ (void)styleBackButton
{
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
    
    // Back Button background image
    UIImage *backButtonPortraitImage = [[UIImage imageNamed:@"BackButton-Portrait"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0, 0, 0)];
    UIImage *backButtonLandscapeImage = [[UIImage imageNamed:@"BackButton-Landscape"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0, 0, 0)];
    [barButtonItemAppearance setBackButtonBackgroundImage:backButtonPortraitImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItemAppearance setBackButtonBackgroundImage:backButtonLandscapeImage forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];

    // Title font, color, style etc...
    [barButtonItemAppearance setTitleTextAttributes:@{
                                UITextAttributeFont: [UIFont systemFontOfSize:15.0],
                           UITextAttributeTextColor: [UIColor whiteColor],
                     UITextAttributeTextShadowColor: [UIColor clearColor],
                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateNormal];
    [barButtonItemAppearance setTitleTextAttributes:@{
                                UITextAttributeFont: [UIFont systemFontOfSize:15.0],
                           UITextAttributeTextColor: [UIColor grayColor],
                     UITextAttributeTextShadowColor: [UIColor clearColor],
                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateHighlighted];
    
    // Title offset
    [barButtonItemAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(3.0, -2.0) forBarMetrics:UIBarMetricsDefault];
    [barButtonItemAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(3.0, -2.0) forBarMetrics:UIBarMetricsLandscapePhone];
}

#pragma mark - UISearchBar Theme

+ (void)styleSearchBar
{
    // Remove the default search bar background.
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    // Create a flat style for the search bar's text field.
    UIImage *searchFieldImage = [[UIImage imageNamed:@"SearchFieldBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
}

@end
