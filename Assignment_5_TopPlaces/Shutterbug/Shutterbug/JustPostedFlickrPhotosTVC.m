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

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // fetch the just posted photos!
  [self fetchPhotos];
}

- (void)fetchPhotos
{
  [self.refreshControl beginRefreshing];
  
  NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
  
  // create (non-main) queue to do fetch on
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [self.refreshControl endRefreshing];
      self.photos = photos;
    });
    
  });
}


@end
