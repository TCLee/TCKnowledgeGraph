//
//  TCDetailViewController.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/12/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDetailViewController.h"
#import "TCFreebaseClient.h"
#import "TCFreebaseTopic.h"
#import "TCFreebaseProperty.h"

#import "MBProgressHUD.h"

@interface TCDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

- (IBAction)showOrHideNavigationBar:(id)sender;

@end

@implementation TCDetailViewController

#pragma mark - Create HTML for UIWebView

- (void)showTopicOnWebView
{
    // Load the template HTML.
    NSURL *htmlFileURL = [[NSBundle mainBundle] URLForResource:@"Topic_Template" withExtension:@"html"];
    NSString *htmlTemplateString = [[NSString alloc] initWithContentsOfURL:htmlFileURL encoding:NSUTF8StringEncoding error:NULL];
    
    // Fill in the placeholders with actual values.
    NSString *htmlString = [[NSString alloc] initWithFormat:htmlTemplateString,
                            self.topic.name,
                            [self imageHTMLString],
                            [self notablePropertiesHTMLString],
                            (self.topic.description ?: @"")];
    
    // Use the bundle URL as our base URL, so that we can load resources using relative URLs.
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];    
}

- (NSString *)imageHTMLString
{
    // No image available, so don't display the <img> element.
    if (!self.topic.imageURLString) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"<img src=\"%@\" alt=\"%@\">",
            self.topic.imageURLString, self.topic.imageAlternateText];
}

- (NSString *)notablePropertiesHTMLString
{
    NSArray *notableProperties = self.topic.notableProperties;
    NSMutableString *htmlString = [[NSMutableString alloc] init];
    
    for (TCFreebaseProperty *property in notableProperties) {        
        [htmlString appendFormat:@"<dt>%@</dt>", property.name];
        [htmlString appendFormat:@"<dd>%@</dd>", [property.values componentsJoinedByString:@", "]];
    }
    
    return htmlString;
}

#pragma mark - View Controller Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the ugly UIWebView shadows.
    for (UIView *subview in self.webView.scrollView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview setHidden:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If no topic selected then there is nothing to load and display.
    if (!self.topic) {
        return;
    }
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.progressHUD.userInteractionEnabled = NO; // Make progress HUD non-modal.
    
    // Fetch the Topic's details from Freebase and display it on the web view.
    [self.topic getTopicWithCompletionHandler:^{
        [self showTopicOnWebView];        
        [self.progressHUD hide:YES];
    }];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // Hide navigation bar for search view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    // When we leave this view, we should cancel any ongoing HTTP requests.
    [self.topic cancel];
    [self.webView stopLoading];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.topic cancel];
    [self.webView stopLoading];    
}

- (void)dealloc
{
    // Remove ourself as delegate when we are deallocated.
    self.tapGestureRecognizer.delegate = nil;
}

#pragma mark - Show/Hide Navigation Bar on Tap

/* Toggle the visibility of the navigation bar when user taps the screen. */
- (IBAction)showOrHideNavigationBar:(id)sender
{
    BOOL isNavigationBarHidden = [self.navigationController isNavigationBarHidden];
    [self.navigationController setNavigationBarHidden:!isNavigationBarHidden animated:YES];
}

/* We have to return YES, so that our custom UITapGestureRecognizer can work with the UIWebView. */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // We only want to handle tapping on the view and nothing else.
    return [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

@end
