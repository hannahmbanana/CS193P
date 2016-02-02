//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Hannah Troisi on 2/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"

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
  self.refreshControl.enabled = YES;
  self.refreshControl.tintColor = [UIColor blueColor];
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
  }
  
  // configure the cell's view
  NSDictionary *place       = self.photos[indexPath.row];
  cell.textLabel.text       = [place valueForKeyPath:FLICKR_PHOTO_TITLE];
  cell.detailTextLabel.text = [place valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
  return cell;
}


@end
