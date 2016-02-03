//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Hannah Troisi on 2/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "NonBlockingImageViewController.h"

@implementation FlickrPhotosTVC

#pragma mark - Properties

// whenever our model is set, update the view
- (void)setPhotos:(NSArray *)photos
{
  _photos = photos;
  
  // reload tableView data
  [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view bringSubviewToFront:self.refreshControl];
  self.navigationItem.title = @"Shutterbug";
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(fetchPhotos) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Helper Methods

- (void)fetchPhotos
{
  NSAssert(NO, @"Error - should not reach this abstract class incomplete method.");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr subtitle cell"];
  
  if (cell == nil) {
    
    // create a cell if none are available
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Flickr subtitle cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  // configure the cell's view
  NSDictionary *place       = self.photos[indexPath.row];
  cell.textLabel.text       = [place valueForKeyPath:FLICKR_PHOTO_TITLE];
  cell.detailTextLabel.text = [place valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NonBlockingImageViewController *imgVC = [[NonBlockingImageViewController alloc] init];
  
  NSDictionary *place = self.photos[indexPath.row];
  imgVC.imgURL = [FlickrFetcher URLforPhoto:place format:FlickrPhotoFormatLarge];
  imgVC.navigationItem.title = [place valueForKeyPath:FLICKR_PHOTO_TITLE];
  imgVC.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  
  BOOL iPad = ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad );
  if (iPad) {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imgVC];
    self.splitViewController.viewControllers = @[self.splitViewController.viewControllers[0], navController];
  } else {
    [self.navigationController pushViewController:imgVC animated:YES];
  }
}

@end
