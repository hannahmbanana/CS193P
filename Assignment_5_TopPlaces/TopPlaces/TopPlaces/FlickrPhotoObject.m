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
@end

#pragma mark - Lifecycle

@implementation FlickrPhotoObject

- (instancetype)initWithDictionary:(NSDictionary *)photoDictionary
{
  self = [super init];
  
  if (self) {
    
    self.dictionaryRepresentation = photoDictionary;
    
    // title
    NSString *titleString = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
    self.title            = ( [titleString isEqualToString:@""] ) ? @"Unknown" : titleString;
    
    // caption
    self.caption = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
  
    // country
    self.country = [photoDictionary valueForKeyPath:FLICKR_PLACE_NAME];
    
    // country components
    self.countryComponents = [self.country componentsSeparatedByString:@","];
  
  }
  
  return self;
}


@end
