//
//  PlaceTableViewController.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/4/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "PlaceTableViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFeedObject.h"
#import "FlickrPhotoObject.h"

@interface PlaceTableViewController ()
@property (nonatomic, strong, readwrite) FlickrFeedObject *flickrFeed;
@end

@implementation PlaceTableViewController


# pragma mark - Properties

- (FlickrFeedObject *)flickrFeed
{
  if (!_flickrFeed) {
    
    _flickrFeed = [[FlickrFeedObject alloc] initWithURL:self.flickrPlaceURL resultsKeyPathString:self.resultsKeyPathString];
  }
  return _flickrFeed;
}


# pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // add the spinner
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(updateFlickrFeed) forControlEvents:UIControlEventValueChanged];
  
  // update FlickrFeed
  [self updateFlickrFeed];
}


#pragma mark - Helper Methods

- (void)updateFlickrFeed
{
  // start the spinner animation
  [self.refreshControl beginRefreshing];
  
  // update flickrFeed
  [self.flickrFeed updateFeedWithCompletionBlock:^{
    
    // reload tableView data
    [self.tableView reloadData];
    
    // stop the spinner animation
    [self.refreshControl endRefreshing];
  }];
}

- (void)saveRecentlyViewedPhoto:(FlickrPhotoObject *)photo
{
  // get user defaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // get recentPhotos array
  NSMutableArray *recentPhotos = [[defaults objectForKey:@"recently viewed photos"] mutableCopy];
  if (recentPhotos == nil) {
    recentPhotos = [[NSMutableArray alloc] init];
  }
  
  // check that photo doesn't already exist in array, if so, remove it
  if ([recentPhotos containsObject:photo.dictionaryRepresentation]) {
    [recentPhotos removeObject:photo.dictionaryRepresentation];
  }
  
  // add photo in chronological order with the most-recently-viewed first and no duplicates
  [recentPhotos insertObject:photo.dictionaryRepresentation atIndex:0];
  
  // 20 most recently viewed only
  if ([recentPhotos count] > 20) {
    recentPhotos = [[recentPhotos subarrayWithRange:NSMakeRange(0, 20)] mutableCopy];
  }
  
  // save to NSUserDefaults
  [defaults setObject:recentPhotos forKey:@"recently viewed photos"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.flickrFeed numItemsInFeed];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topPlaceCell"];
 
  // if no reusable cells available, create a new one
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topPlaceCell"];
  }
  
  // configure cell using photo's metadata
  FlickrPhotoObject *photo  = [self.flickrFeed itemAtIndex:indexPath.row];
  
  cell.textLabel.text       = photo.title;
  cell.detailTextLabel.text = photo.caption;
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  FlickrPhotoObject *photo    = [self.flickrFeed itemAtIndex:indexPath.row];
  NSURL *photoURL             = [FlickrFetcher URLforPhoto:photo.dictionaryRepresentation format:FlickrPhotoFormatLarge];
  
  ImageViewController *imgVC  = [[ImageViewController alloc] init];
  imgVC.imageURL              = photoURL;
  imgVC.navigationItem.title  = [photo valueForKeyPath:@"title"];
  
  [self.navigationController pushViewController:imgVC animated:YES];
  
  // SAVE PHOTO
  [self saveRecentlyViewedPhoto:photo];
}

@end

