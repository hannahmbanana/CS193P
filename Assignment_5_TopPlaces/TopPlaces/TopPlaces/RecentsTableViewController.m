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
}

@end
