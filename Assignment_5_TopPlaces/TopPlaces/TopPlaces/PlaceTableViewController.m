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

@interface PlaceTableViewController ()
@property (nonatomic, strong, readwrite) NSArray *photos;
@end

@implementation PlaceTableViewController

# pragma mark - Properties

- (void)setFlickrPlaceURL:(NSURL *)flickrPlaceURL
{
  _flickrPlaceURL = flickrPlaceURL;

  [self fetchPhotos];
}

- (void)setPhotos:(NSArray *)photos
{
  _photos = photos;
  
  // whenever our model is updated, reload the data table
  [self.tableView reloadData];
}

# pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // add the spinner
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(fetchPhotos) forControlEvents:UIControlEventValueChanged];
  
  // fetchPhotos
  [self fetchPhotos];    // QUESTION: why is this the best lifecycle method to put this in?
}


#pragma mark - Helper Methods

- (void)fetchPhotos
{
  // start the spinner animation
  [self.refreshControl beginRefreshing];
  
  // download off main thread
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // FETCH TOP PLACES
    
    // fetch the JSON data from Flickr
    NSData *jsonData = [NSData dataWithContentsOfURL:self.flickrPlaceURL];
    
    // convert it to a Property List (NSArray and NSDictionary)
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    // get the NSArray of place NSDictionarys out of the results
    NSArray *photos = [propertyListResults valueForKeyPath:@"photos.photo"];
    
//    NSLog(@"%@", photos);
    
    // update the Model (and thus our UI), but do so back on the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
      
      // stop the spinner animation
      [self.refreshControl endRefreshing];
      
      // update the photos model
      self.photos = photos;
      
    });
  });
}

- (void)saveRecentlyViewedPhoto:(NSDictionary *)photoDictionary
{
  // get user defaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // get recentPhotos array
  NSMutableArray *recentPhotos = [[defaults objectForKey:@"recently viewed photos"] mutableCopy];
  if (recentPhotos == nil) {
    recentPhotos = [[NSMutableArray alloc] init];
  }
  
  // check that photo doesn't already exist in array, if so, remove it
  if ([recentPhotos containsObject:photoDictionary]) {
    NSUInteger objectIndex = [recentPhotos indexOfObjectIdenticalTo:photoDictionary];
    [recentPhotos removeObjectAtIndex:objectIndex];
  }
  
  // add photo in chronological order with the most-recently-viewed first and no duplicates
  [recentPhotos insertObject:photoDictionary atIndex:0];
  
  // 20 most recently viewed only
  if ([recentPhotos count] > 20) {
    recentPhotos = [[recentPhotos subarrayWithRange:NSMakeRange(0, 20)] mutableCopy];
  }
  
  // save to NSUserDefaults
  [defaults setObject:recentPhotos forKey:@"recently viewed photos"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topPlaceCell"];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topPlaceCell"];
  }
  
  NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
  NSString *title = [photo valueForKeyPath:@"title"];
  
  cell.textLabel.text = ([title isEqualToString:@""]) ? @"Unknown" : title;
  cell.detailTextLabel.text = [photo valueForKeyPath:@"description._content"];
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
  NSURL *photoURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
  
  ImageViewController *imgVC = [[ImageViewController alloc] init];
  imgVC.imageURL = photoURL;
  imgVC.navigationItem.title = [photo valueForKeyPath:@"title"];
  [self.navigationController pushViewController:imgVC animated:YES];
  
  // SAVE PHOTO
  [self saveRecentlyViewedPhoto:photo];
}

@end

