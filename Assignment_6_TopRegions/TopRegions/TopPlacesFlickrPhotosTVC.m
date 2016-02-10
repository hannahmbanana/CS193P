//
//  TopPlacesFlickrPhotosTVC.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/3/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "TopPlacesFlickrPhotosTVC.h"
#import "PlaceFlickrPhotosTVC.h"
#import "FlickrTopPlaceTVCell.h"


@implementation TopPlacesFlickrPhotosTVC


# pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title = @"Top Places";
}


#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FlickrPhotoObject *photo = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];
  
  FlickrTopPlaceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[FlickrTopPlaceTVCell reuseIdentifier]];
  // if no reusable cells available, create a new one
  if (cell == nil) {
    cell = [[FlickrTopPlaceTVCell alloc] initWithPhoto:photo];
  } else {
    [cell updateCellWithPhoto:photo];
  }
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
  FlickrPhotoObject *place  = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];
  NSString *placeID         = [place.dictionaryRepresentation valueForKeyPath:@"place_id"];
  NSURL *photosURL          = [FlickrFetcher URLforPhotosInPlace:placeID maxResults:50];
  
  PlaceFlickrPhotosTVC *imgVC = [[PlaceFlickrPhotosTVC alloc] initWithURL:photosURL resultsKeyPathString:FLICKR_RESULTS_PHOTOS];
  imgVC.navigationItem.title = [place.countryComponents firstObject];
  [self.navigationController pushViewController:imgVC animated:YES];
}

@end
