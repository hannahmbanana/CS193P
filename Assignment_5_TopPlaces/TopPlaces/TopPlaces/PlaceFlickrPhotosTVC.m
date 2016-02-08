//
//  PlaceFlickrPhotosTVC.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/4/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "PlaceFlickrPhotosTVC.h"
#import "ImageViewController.h"
#import "FlickrPhotoObject.h"


@implementation PlaceFlickrPhotosTVC


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.flickrFeed numItemsInFeedAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topPlaceCell"];
 
  // if no reusable cells available, create a new one
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topPlaceCell"];
  }
  
  // configure cell using photo's metadata
  FlickrPhotoObject *photo  = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];
  
  cell.textLabel.text       = photo.title;
  cell.detailTextLabel.text = photo.caption;
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  FlickrPhotoObject *photo    = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];
  NSURL *photoURL             = [FlickrFetcher URLforPhoto:photo.dictionaryRepresentation format:FlickrPhotoFormatLarge];
  
  ImageViewController *imgVC  = [[ImageViewController alloc] init];
  imgVC.imageURL              = photoURL;
  imgVC.navigationItem.title  = [photo valueForKeyPath:@"title"];
  
  if (self.splitViewController) {
    
    // iPad
    imgVC.navigationItem.leftBarButtonItem    = self.splitViewController.displayModeButtonItem;

    NSArray *splitViewControllers             = self.splitViewController.viewControllers;
    UINavigationController *navController     = splitViewControllers[1];
    [navController setViewControllers:[NSArray arrayWithObject:imgVC] animated:NO];
    self.splitViewController.viewControllers  = @[splitViewControllers[0], navController];
    
  } else {
    
    // iPhone
    [self.navigationController pushViewController:imgVC animated:YES];
  }
  
  // SAVE PHOTO
  [NSUserDefaults addUsersRecentlyViewedPhoto:photo];
}

@end

