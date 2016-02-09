//
//  FlickrTopPlaceTVCell.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/8/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrTopPlaceTVCell.h"

@implementation FlickrTopPlaceTVCell


#pragma mark - Class Methods

+ (NSString *)reuseIdentifier
{
  return @"flickrTopPlaceTVCell";
}


#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(FlickrPhotoObject *)photo;
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"flickrTopPlaceTVCell"];
  
  if (self) {
    [self updateCellWithPhoto:photo];
  }
  return self;
}


#pragma mark - Instance Methods

- (void)updateCellWithPhoto:(FlickrPhotoObject *)photo;
{
  self.textLabel.text       = [photo.countryComponents firstObject];
  self.detailTextLabel.text = [photo.countryComponents componentsJoinedByString:@" "];
}


@end