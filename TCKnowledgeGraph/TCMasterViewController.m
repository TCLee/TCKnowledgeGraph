//
//  TCMasterViewController.m
//  TCKnowledgeGraph
//
//  Created by Lee Tze Cheun on 6/12/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMasterViewController.h"
#import "TCDetailViewController.h"
#import "TCFreebaseSearch.h"
#import "TCFreebaseTopic.h"

@interface TCMasterViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation TCMasterViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Set focus to the UISearchBar, so that user can start
    // entering their query right away.
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Show navigation bar for the detail view, so that we can navigate back to this search view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Dismiss the keyboard when this view goes away.
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    self.searchResults = nil;
}

- (void)dealloc
{
    // Remember to nil out the UISearchBar's delegate property when we are deallocated.
    // Otherwise, UISearchBar will refer to a deallocated delegate.
    self.searchBar.delegate = nil;
}

#pragma mark - Search Bar Delegate

/* As user type we will fetch the list of search suggestions in the background. */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // If user deleted the search text, we should not waste resources sending an
    // empty query string to Freebase API.
    if (!searchText || 0 == [searchText length]) {
        self.searchResults = nil;
        [self.tableView reloadData];
        return;
    }
    
    // Fetch a list of suggested Freebase topics for the user's search text.
    [[TCFreebaseSearchService sharedService] searchForQuery:searchText completionHandler:^(NSArray *searchResults) {
        
        // It is possible that the UISearchBar's text has changed when we return
        // from the network with the search results. If it has changed, we should not
        // display stale results on the table view.
        if ([searchText isEqualToString:searchBar.text]) {
            self.searchResults = searchResults;
            [self.tableView reloadData];
        }
    }];
                
}

#pragma mark - Table View Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchResults) {
        return 0;
    }
    
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSuggestionCell"
                                                            forIndexPath:indexPath];
        
    TCFreebaseSearchResult *searchResult = self.searchResults[indexPath.row];
    cell.textLabel.text = searchResult.topicName;
    cell.detailTextLabel.text = searchResult.notableName;    
    return cell;
}


#pragma mark - Storyboard Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TCFreebaseSearchResult *searchResult = self.searchResults[indexPath.row];
        
        TCDetailViewController *detailViewController = (TCDetailViewController *)[segue destinationViewController];
        detailViewController.topic = [[TCFreebaseTopic alloc] initWithID:searchResult.topicID
                                                                    name:searchResult.topicName];
    }
}

@end
