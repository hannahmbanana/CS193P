//
//  RecentsTableViewController.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoObject.h"
#import "NSUserDefaults+RecentlyViewedPhotos.h"
#import "FlickrPhotoTVCell.h"


@interface RecentsTableViewController ()
@property (nonatomic, strong, readwrite) NSArray             *photos;
@property (nonatomic, strong, readwrite) ImageViewController *imageVC;
@end

@implementation RecentsTableViewController

#define CELL_HEIGHT 90

#pragma mark - Properties

- (ImageViewController *)imageVC
{
  if (!_imageVC) {
    _imageVC = [[ImageViewController alloc] init];
    _imageVC.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  }
  return _imageVC;
}

- (void)setPhotos:(NSArray *)photos
{
  _photos = photos;
  
  // whenever our model is updated, reload the data table
  [self.tableView reloadData];
}


# pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0);

  self.navigationItem.title = @"Recently Viewed";
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(clearRecentlyViewedPhotos)];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // fetchPhotos
  [self fetchPhotos];
}


#pragma mark - Helper Methods

- (void)fetchPhotos
{
  self.photos = nil;
  
  // get user defaults
  NSArray *photoDictionaryArray = [NSUserDefaults getUsersRecentlyViewedPhotos];
  
  // download FlickrFeed off main thread
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // CREATE FLICKR PHOTO OBJECTS
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSDictionary *photoDictionary in photoDictionaryArray) {
      
      // create FlickrPhotoObject from json dictionary
      FlickrPhotoObject *photoObject = [[FlickrPhotoObject alloc] initWithDictionary:photoDictionary];
      
      // add FlickrPhotoObject to array
      [photos addObject:photoObject];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.view setNeedsLayout];
      });
    }
    
    // set photos property
    self.photos = photos;
  });
}

- (void)clearRecentlyViewedPhotos
{
  self.photos = nil;
  
  [NSUserDefaults resetUsersRecentlyViewedPhotos];
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FlickrPhotoObject *photo = [self.photos objectAtIndex:indexPath.row];
  
  FlickrPhotoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[FlickrPhotoTVCell reuseIdentifier]];
  // if no reusable cells available, create a new one
  if (cell == nil) {
    cell = [[FlickrPhotoTVCell alloc] initWithPhoto:photo];
  } else {
    [cell updateCellWithPhoto:photo];
  }
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  FlickrPhotoObject *photo = [self.photos objectAtIndex:indexPath.row];
  
  // configure imageViewController
  ImageViewController *imageVC = self.imageVC;
  imageVC.imageURL = [FlickrFetcher URLforPhoto:photo.dictionaryRepresentation format:FlickrPhotoFormatLarge];
  imageVC.navigationItem.title = [photo valueForKeyPath:@"title"];
  
  if (self.splitViewController) {
    
    // iPad
    NSArray *splitViewControllers = self.splitViewController.viewControllers;
    UINavigationController *navController = splitViewControllers[1];
    [navController setViewControllers:[NSArray arrayWithObject:imageVC] animated:NO];
    self.splitViewController.viewControllers = @[splitViewControllers[0], navController];
    
  } else {
    
    // iPhone
    [self.navigationController pushViewController:imageVC animated:YES];
  }
  
  // save recently viewed photos
  [NSUserDefaults addUsersRecentlyViewedPhoto:photo];
}

@end
