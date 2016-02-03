//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Hannah Troisi on 2/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC

// an argument can be made that this should be done in viewWillAppear:
//   (that way, the expensive operation of fetching will only happen
//    if our View is FOR SURE going to appear on screen).
// however, we'd have to be sure it only happens the first time
//   that viewWillAppear: is called, not on subsequent appearances

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  // fetch the just posted photos!
  [self fetchPhotos];
}

- (void)fetchPhotos
{
  // start the spinner animation
  [self.refreshControl beginRefreshing];
  
  NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
  
  // create (non-main) queue to do fetch on, give it default priority
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // fetch the JSON data from Flickr
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    // convert it to a Property List (NSArray and NSDictionary)
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    // get the NSArray of photo NSDictionarys out of the results
    NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    
    // update the Model (and thus our UI), but do so back on the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
      
      // stop the spinner animation
      [self.refreshControl endRefreshing];
      
      // update the photos model
      self.photos = photos;
    });
    
  });
}


@end
