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
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(clearRecentPhotos)];
}

#warning TopPlaces[24540:7584204] Attempting to change the refresh control while it is not idle is strongly discouraged and probably won't work properly.

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
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
  
  // get user defaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  self.photos = [defaults objectForKey:@"recently viewed photos"];
}

- (void)clearRecentPhotos
{
  self.photos = nil;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:@"recently viewed photos"];
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
  
  #warning - FINISH Thumbnail pic - subclass?

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
}

@end
