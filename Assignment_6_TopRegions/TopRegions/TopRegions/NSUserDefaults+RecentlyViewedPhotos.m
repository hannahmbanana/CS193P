//
//  NSUserDefaults+RecentlyViewedPhotos.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/7/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "NSUserDefaults+RecentlyViewedPhotos.h"

@implementation NSUserDefaults (RecentlyViewedPhotos)

+ (void)resetUsersRecentlyViewedPhotos
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:@"recently viewed photos"];
}

+ (NSArray *)getUsersRecentlyViewedPhotos
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  return [defaults objectForKey:@"recently viewed photos"];
}

+ (void)addUsersRecentlyViewedPhoto:(FlickrPhotoObject *)photo
{
  if (photo) {
    
    // get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // get recent photos array
    NSMutableArray *recentPhotos = [[defaults objectForKey:@"recently viewed photos"] mutableCopy];
    if (recentPhotos == nil) {
      recentPhotos = [[NSMutableArray alloc] init];
    }
    
    // check that photo doesn't already exist in array, if so, remove it
    if ([recentPhotos containsObject:photo.dictionaryRepresentation]) {
      [recentPhotos removeObject:photo.dictionaryRepresentation];
    }
    
    // add photo in chronological order with the most-recently-viewed first and no duplicates
    [recentPhotos insertObject:photo.dictionaryRepresentation atIndex:0];
    
    // keep 20 most recently viewed only
    if ([recentPhotos count] > 20) {
      recentPhotos = [[recentPhotos subarrayWithRange:NSMakeRange(0, 20)] mutableCopy];
    }
    
    // save to NSUserDefaults
    [defaults setObject:recentPhotos forKey:@"recently viewed photos"];
    
  } else {
    NSLog(@"Could not save photo!");
  }
}

@end
