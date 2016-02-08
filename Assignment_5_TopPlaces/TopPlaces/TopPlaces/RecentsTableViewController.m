//
//  RecentsTableViewController.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoObject.h"
#import "NSUserDefaults+RecentlyViewedPhotos.h"


@interface RecentsTableViewController ()
@property (nonatomic, strong, readwrite) NSArray *photos;
@end

@implementation RecentsTableViewController


#pragma mark - Properties

- (void)setPhotos:(NSArray *)photos
{
  _photos = photos;
  
  // stop the spinner
  [self.refreshControl endRefreshing];
  
  // whenever our model is updated, reload the data table
  [self.tableView reloadData];
}


# pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
#warning - why do I need to hack this?
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0);

  self.navigationItem.title = @"Recently Viewed Photos";
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(clearRecentPhotos)];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // add the spinner
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(fetchPhotos) forControlEvents:UIControlEventValueChanged];
  
  // fetchPhotos
  [self fetchPhotos];
#warning Only want to fetchPhotos when pushing the view controller, not when returning from individual picture view
}


#pragma mark - Helper Methods

- (void)fetchPhotos
{
  self.photos = nil;
  
  // start the spinner animation
  [self.refreshControl beginRefreshing];
  
  // get user defaults
  NSArray *photoDictionaryArray = [NSUserDefaults getUsersRecentlyViewedPhotos];
  
  // download FlickrFeed off main thread
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // CREATE FLICKR PHOTO OBJECTS
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSDictionary *photoDictionary in photoDictionaryArray) {
      
      // create FlickrPhotoObject from json dictionary
      FlickrPhotoObject *photoObject = [[FlickrPhotoObject alloc] initWithDictionary:photoDictionary];
      
      // add FlickrPhotoObject to array
      [photos addObject:photoObject];
    }
    
    // set photos property
    self.photos = photos;
  });
}

- (void)clearRecentPhotos
{
  self.photos = nil;
  
  [NSUserDefaults resetUsersRecentlyViewedPhotos];
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
  NSLog(@"ContentOffset = %f", self.tableView.contentInset.top);

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topPlaceCell"];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topPlaceCell"];
  }
  
#warning Add thumbnail photo
  NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
  NSString *title = [photo valueForKeyPath:@"title"];
  
  cell.textLabel.text = title;

  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  FlickrPhotoObject *photo    = [self.photos objectAtIndex:indexPath.row];
  NSURL *photoURL             = [FlickrFetcher URLforPhoto:photo.dictionaryRepresentation format:FlickrPhotoFormatLarge];
  
  ImageViewController *imgVC  = [[ImageViewController alloc] init];
  imgVC.imageURL              = photoURL;
  imgVC.navigationItem.title  = [photo valueForKeyPath:@"title"];
  
  [self.navigationController pushViewController:imgVC animated:YES];
}

@end
