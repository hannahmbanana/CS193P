//
//  FlickrPhotoObject.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrPhotoObject.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoObject ()

@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *description;

@end


#pragma mark - Lifecycle

@implementation FlickrPhotoObject

- (instancetype)initWithDictionary:(NSDictionary *)photoDictionary
{
  self = [super init];
  
  if (self) {
    
    // title
    NSString *titleString = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
    self.title            = ( [titleString isEqualToString:@""] ) ? @"Unknown" : self.title;
    
    // description
    self.description      = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
  }
  
  return self;
}

@end
