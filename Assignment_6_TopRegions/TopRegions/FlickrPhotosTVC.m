//
//  FlickrPhotosTVC.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/7/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrPhotosTVC.h"

@interface FlickrPhotosTVC ()

@property (nonatomic, strong, readwrite) NSURL                   *flickrPlaceURL;
@property (nonatomic, strong, readwrite) NSString                *resultsKeyPathString;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *firstTimePageLoadSpinner;

@end

@implementation FlickrPhotosTVC


#pragma mark - Properties

- (FlickrFeedObject *)flickrFeed
{
  if (!_flickrFeed) {
    _flickrFeed = [[FlickrFeedObject alloc] initWithURL:self.flickrPlaceURL resultsKeyPathString:self.resultsKeyPathString];
  }
  return _flickrFeed;
}

// the first time the table loads, if the data loads quickly enough the refreshControl will go on and off so fast that the
// user won't see it and instead will percieve that the table "jumps". Thus, create a UIActivityIndicatorView
// in the middle of the page for first time loads only.

- (UIActivityIndicatorView *)firstTimePageLoadSpinner
{
  if (!_firstTimePageLoadSpinner) {
    _firstTimePageLoadSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _firstTimePageLoadSpinner.color = [UIColor darkGrayColor];
    _firstTimePageLoadSpinner.hidesWhenStopped = YES;
  }
  return _firstTimePageLoadSpinner;
}


#pragma mark - Lifecycle

- (instancetype)initWithURL:(NSURL *)url resultsKeyPathString:(NSString *)keyPath;
{
  self = [super initWithStyle:UITableViewStylePlain];
  
  if (self) {
    
    // set properties
    self.flickrPlaceURL = url;
    self.resultsKeyPathString = keyPath;
    
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  // configure the tableView's refreshControl
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(updateFlickrFeed) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  CGSize visibleRect = self.view.bounds.size;

  // layout firstTimePageLoadSpinner
  [self.firstTimePageLoadSpinner sizeToFit];
  
  CGSize spinnerSize = self.firstTimePageLoadSpinner.bounds.size;
  
  self.firstTimePageLoadSpinner.frame = CGRectMake((visibleRect.width - spinnerSize.width)/2,
                                                   (visibleRect.height - spinnerSize.height)/2 - self.tableView.contentInset.top,
                                                   spinnerSize.width,
                                                   spinnerSize.height);
  
  // add firstTimePageLoadSpinner as subview
  [self.view addSubview:self.firstTimePageLoadSpinner];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self updateFlickrFeed];
}

#pragma mark - Helper Methods

- (void)updateFlickrFeed
{
  [self startDataLoadAnimations];
  
  // update flickrFeed
  [self.flickrFeed updateFeedWithCompletionBlock:^{
    
    // reload tableView data
    [self.tableView reloadData];
    
    // stop the spinner animation
    [self stopDataLoadAnimations];
  }];
}
   
- (void)startDataLoadAnimations
{
  // start the spinner animation
  if (!self.flickrFeed.firstTimeLoadComplete) {
    
    // 1st time tableView loads
    [self.firstTimePageLoadSpinner startAnimating];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
  }
}
   
- (void)stopDataLoadAnimations
{
  [self.refreshControl endRefreshing];
  [self.firstTimePageLoadSpinner stopAnimating];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.flickrFeed numSectionsInFeed];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.flickrFeed numItemsInFeedAtSection:section];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
  return [self.flickrFeed.countries objectAtIndex:section];
}


@end