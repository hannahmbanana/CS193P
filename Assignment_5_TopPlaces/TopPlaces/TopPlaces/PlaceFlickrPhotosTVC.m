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

@interface PlaceFlickrPhotosTVC ()
@property (nonatomic, strong, readwrite) ImageViewController *imageVC;
@end

@implementation PlaceFlickrPhotosTVC


#pragma mark - Properties

- (ImageViewController *)imageVC
{
  if (!_imageVC) {
    _imageVC = [[ImageViewController alloc] init];
    _imageVC.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  }
  return _imageVC;
}

#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topPlaceCell"];
 
  // if no reusable cells available, create a new one
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topPlaceCell"];
  }
  
  // configure cell using photo's metadata
  FlickrPhotoObject *photo = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];
  
  cell.textLabel.text = photo.title;
  cell.detailTextLabel.text = photo.caption;
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  FlickrPhotoObject *photo = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];
  
  // configure imageViewController
  ImageViewController *imageVC = self.imageVC;
  imageVC.imageURL = [FlickrFetcher URLforPhoto:photo.dictionaryRepresentation format:FlickrPhotoFormatLarge];
  imageVC.navigationItem.title = [photo valueForKeyPath:@"title"];

  if (self.splitViewController) {
    
    // iPad
    NSArray *splitViewControllers = self.splitViewController.viewControllers;
    UINavigationController *navController = splitViewControllers[1];
    [navController setViewControllers:[NSArray arrayWithObject:imageVC] animated:NO];
    self.splitViewController.viewControllers = @[splitViewControllers[0], navController];
    
  } else {
    
    // iPhone
    [self.navigationController pushViewController:imageVC animated:YES];
  }
  
  // save recently viewed photos
  [NSUserDefaults addUsersRecentlyViewedPhoto:photo];
}

@end

