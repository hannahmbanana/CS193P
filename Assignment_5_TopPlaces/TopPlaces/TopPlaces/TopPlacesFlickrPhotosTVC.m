//
//  TopPlacesFlickrPhotosTVC.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/3/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "TopPlacesFlickrPhotosTVC.h"
#import "PlaceFlickrPhotosTVC.h"

@implementation TopPlacesFlickrPhotosTVC


# pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title = @"Top Places";
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.flickrFeed.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.flickrFeed numItemsInFeedAtSection:section];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
  return [self.flickrFeed.countries objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusableCell"];
    
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reusableCell"];
  }
  
  FlickrPhotoObject *photo  = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];

  NSArray *components = [photo.country componentsSeparatedByString:@","];
  NSString *locality  = [components firstObject];
  NSString *location  = [components componentsJoinedByString:@" "];
  
  cell.textLabel.text = locality;
  cell.detailTextLabel.text = location;

  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
  FlickrPhotoObject *place  = [self.flickrFeed itemAtIndex:indexPath.row inSection:indexPath.section];
  NSString *placeID         = [place.dictionaryRepresentation valueForKeyPath:@"place_id"];
  NSURL *photosURL          = [FlickrFetcher URLforPhotosInPlace:placeID maxResults:50];
  
  PlaceFlickrPhotosTVC *imgVC = [[PlaceFlickrPhotosTVC alloc] initWithURL:photosURL resultsKeyPathString:FLICKR_RESULTS_PHOTOS];
  [self.navigationController pushViewController:imgVC animated:YES];
}

@end
