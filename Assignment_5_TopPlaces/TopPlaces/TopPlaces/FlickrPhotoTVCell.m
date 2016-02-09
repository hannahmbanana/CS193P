//
//  FlickrPhotoTVCell.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/7/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrPhotoTVCell.h"

@implementation FlickrPhotoTVCell


#pragma mark - Class Methods

+ (NSString *)reuseIdentifier
{
  return @"flickrPhotoTVCell";
}


#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(FlickrPhotoObject *)photo;
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"flickrPhotoTVCell"];
  
  if (self) {
    [self updateCellWithPhoto:photo];
  }
  return self;
}

- (void)updateCellWithPhoto:(FlickrPhotoObject *)photo;
{
  self.textLabel.text       = photo.title;
  self.detailTextLabel.text = photo.caption;
}

@end
