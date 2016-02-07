//
//  FlickrFeedObject.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrFeedObject.h"

@interface FlickrFeedObject ()

@property (nonatomic, strong, readwrite) NSURL    *URL;
@property (nonatomic, strong, readwrite) NSString *resultsKeyPathString;
@property (nonatomic, strong, readwrite) NSArray  *flickrFeedItems;          // of FlickrPhotoObjects

@end

@implementation FlickrFeedObject


#pragma mark - Lifecycle

- (instancetype)initWithURL:(NSURL *)url resultsKeyPathString:(NSString *)keyPath;
{
  self = [super init];
  
  if (self) {
    
    // set properties
    self.URL = url;
    self.resultsKeyPathString = keyPath;
  
  }
  
  return self;
}


#pragma mark - Instance Methods

- (void)updateFeedWithCompletionBlock:(void (^)(void))blockName
{
  self.flickrFeedItems = nil;
  
  // download FlickrFeed off main thread
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // QUERY SERVER
    
    // fetch the JSON data from Flickr
    NSData *jsonData = [NSData dataWithContentsOfURL:self.URL];
    
    // convert it to a Property List (NSArray and NSDictionary)
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    // get the NSArray of item NSDictionaries out of the results
    NSArray *items = [propertyListResults valueForKeyPath:self.resultsKeyPathString];
    
    // CREATE FLICKR PHOTO OBJECTS
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSDictionary *photoDictionary in items) {
      
      // create FlickrPhotoObject from json dictionary
      FlickrPhotoObject *photoObject = [[FlickrPhotoObject alloc] initWithDictionary:photoDictionary];
    
      // add FlickrPhotoObject to array
      [photos addObject:photoObject];
    }
    
    // set FlickrFeedObject array of photos
    self.flickrFeedItems = photos;
    
    // completion block
    dispatch_async(dispatch_get_main_queue(), ^{
      
      // call the block argument
      blockName();
    });
    
  });
}

- (NSUInteger)numItemsInFeed
{
  return [self.flickrFeedItems count];
}

- (FlickrPhotoObject *)itemAtIndex:(NSUInteger)index
{
  return [self.flickrFeedItems objectAtIndex:index];
}

- (NSArray *)orderedCountriesArray
{
  ///// create set of countries
  NSMutableSet *countrySet = [NSMutableSet set];
  
  // print country order
  for (FlickrPhotoObject *photo in self.flickrFeedItems) {

    NSString *country = [[photo.country componentsSeparatedByString:@","] lastObject];
    [countrySet addObject:country];
    
  }
  
  // order the countries
  NSMutableArray *countriesArray = [[countrySet allObjects] mutableCopy];
  NSArray *countryOrderedArray = [NSArray array];
  countryOrderedArray = [countriesArray sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
  
  return countryOrderedArray;
}

@end
