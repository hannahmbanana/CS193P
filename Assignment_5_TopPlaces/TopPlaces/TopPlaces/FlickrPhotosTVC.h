//
//  FlickrPhotosTVC.h
//  TopPlaces
//
//  Created by Hannah Troisi on 2/7/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFeedObject.h"
#import "FlickrFetcher.h"
#import "NSUserDefaults+RecentlyViewedPhotos.h"


@interface FlickrPhotosTVC : UITableViewController

@property (nonatomic, strong, readwrite) FlickrFeedObject        *flickrFeed;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url resultsKeyPathString:(NSString *)keyPath NS_DESIGNATED_INITIALIZER;
@end
