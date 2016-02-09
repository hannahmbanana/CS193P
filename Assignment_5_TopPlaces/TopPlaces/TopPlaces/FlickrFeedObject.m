//
//  FlickrFeedObject.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrFeedObject.h"
#import "FlickrFetcher.h"

@interface FlickrFeedObject ()

@property (nonatomic, strong, readwrite) NSURL    *URL;
@property (nonatomic, strong, readwrite) NSString *resultsKeyPathString;
@property (nonatomic, strong, readwrite) NSArray  *flickrFeedItems;          // of FlickrPhotoObjects
@property (nonatomic, strong, readwrite) NSArray  *countries;
@property (nonatomic, assign, readwrite) BOOL     firstTimeLoadComplete;

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
  self.countries = nil;
  
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
    
    NSString *keyPath = self.resultsKeyPathString;
    
    if ( [keyPath isEqualToString:FLICKR_RESULTS_PLACES] ) {
      
      // get orderedCountriesArray
      NSArray *countryOrderedArray = [FlickrFeedObject orderedCountriesFromPlaces:photos];
      self.countries = countryOrderedArray;
      
      ///// create the places ordered list
      NSMutableArray *placesSorted = [NSMutableArray array];
      for (int i = 0; i < [countryOrderedArray count]; i++) {
        [placesSorted addObject:[NSMutableArray array]];
      }
      
      // add places to country sublists
      for (FlickrPhotoObject *place in photos) {
        NSString *country = [place.countryComponents lastObject];
        NSUInteger countryIndex = [countryOrderedArray indexOfObject:country];
        
        NSMutableArray *subArray = [placesSorted objectAtIndex:countryIndex];
        [subArray insertObject:place atIndex:0];
      }
      
      // sort country sublists
      for (NSMutableArray *array in placesSorted) {
        
        [array sortUsingComparator:^NSComparisonResult(FlickrPhotoObject *obj1, FlickrPhotoObject *obj2) {
          NSString *country1 = [obj1.countryComponents firstObject];
          NSString *country2 = [obj2.countryComponents firstObject];
          return [country1 localizedCaseInsensitiveCompare:country2];
        }];
        
      }
      
      // set FlickrFeedObject array of photos
      self.flickrFeedItems = placesSorted;
      
    } else {
      self.flickrFeedItems = photos;
    }
    
    self.firstTimeLoadComplete = YES;
    
    // completion block
    dispatch_async(dispatch_get_main_queue(), ^{
      
      // call the block argument
      blockName();
    });
    
  });
}

- (NSUInteger)numSectionsInFeed
{
  if ( [self.resultsKeyPathString isEqualToString:FLICKR_RESULTS_PLACES] ) {
    return [self.countries count];
  } else {
    return 1;
  }
}

- (NSUInteger)numItemsInFeedAtSection:(NSUInteger)section
{
  if ( [self.resultsKeyPathString isEqualToString:FLICKR_RESULTS_PLACES] ) {
    return [[self.flickrFeedItems objectAtIndex:section] count];
  } else {
    return [self.flickrFeedItems count];
  }
}

- (FlickrPhotoObject *)itemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
  if ( [self.resultsKeyPathString isEqualToString:FLICKR_RESULTS_PLACES] ) {
    return [[self.flickrFeedItems objectAtIndex:section] objectAtIndex:index];
  } else {
    return [self.flickrFeedItems objectAtIndex:index];
  }
}

+ (NSArray *)orderedCountriesFromPlaces:(NSArray *)places
{
  ///// create set of countries
  NSMutableSet *countrySet = [NSMutableSet set];
  
  // print country order
  for (FlickrPhotoObject *photo in places) {

    NSString *country = [photo.countryComponents lastObject];
    [countrySet addObject:country];
    
  }
  
  // order the countries
  NSMutableArray *countriesArray = [[countrySet allObjects] mutableCopy];
  NSArray *countryOrderedArray = [NSArray array];
  countryOrderedArray = [countriesArray sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
  
  return countryOrderedArray;
}

@end
