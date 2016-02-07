//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/3/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "PlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFeedObject.h"


@interface TopPlacesTableViewController ()
@property (nonatomic, strong, readwrite) FlickrFeedObject        *flickrFeed;
@property (nonatomic, strong, readwrite) NSArray                 *places;
@property (nonatomic, strong, readwrite) NSArray                 *countries;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *spinner;
@end


@implementation TopPlacesTableViewController

# pragma mark - Properties

- (FlickrFeedObject *)flickrFeed
{
  if (!_flickrFeed) {
    
    _flickrFeed = [[FlickrFeedObject alloc] initWithURL:[FlickrFetcher URLforTopPlaces] resultsKeyPathString:FLICKR_RESULTS_PLACES];
  }
  return _flickrFeed;
}

//- (void)setPlaces:(NSArray *)places
//{
//  _places = places;
//  
//  // stop the spinner animation
//  [self.refreshControl endRefreshing];
//  [self.spinner stopAnimating];
//  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//
////  self.tableView.hidden = NO;
//  
//  // whenever our model is updated, reload the data table
//  [self.tableView reloadData];
//}

- (UIActivityIndicatorView *)spinner
{
  if (!_spinner) {
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.hidesWhenStopped = YES;
    _spinner.color = [UIColor darkGrayColor];
  }
  return _spinner;
}


# pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title = @"Top Places";
  self.view.backgroundColor = [UIColor whiteColor];
  
  // add the spinner (to avoid the jump for fast loads)
  
  // add the UITableView pull to refresh spinner
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(updateFlickrFeed) forControlEvents:UIControlEventValueChanged];
  
  // fetchTopPlaces
//  [self updateFlickrFeed];    // QUESTION: why is this the best lifecycle method to put this in?
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  [self.spinner sizeToFit];
  CGSize spinnerSize = self.spinner.bounds.size;
  CGSize visibleRect = self.view.bounds.size;
  self.spinner.frame = CGRectMake((visibleRect.width - spinnerSize.width)/2,
                                  (visibleRect.height - spinnerSize.height)/2 - self.tableView.contentInset.top,
                                  spinnerSize.width,
                                  spinnerSize.height);
  
  [self.view addSubview:self.spinner];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // update FlickrFeed
  [self updateFlickrFeed];
}

#pragma mark - Helper Methods

- (void)updateFlickrFeed
{
  // start the spinner animation
    if ([self.places count]) {
      [self.refreshControl beginRefreshing];
    } else {
      [self.spinner startAnimating];
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //    self.tableView.hidden = YES;
    }
  
  // update flickrFeed
  [self.flickrFeed updateFeedWithCompletionBlock:^{
    
    self.countries = [self.flickrFeed orderedCountriesArray];

    // reload tableView data
    [self.tableView reloadData];
    
    // stop the spinner animation
    [self.refreshControl endRefreshing];
    [self.spinner stopAnimating];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
#warning move to object
  }];
}

//- (void)fetchFlickrTopPlaces
//{
//  // start the spinner animation
//  if ([self.places count]) {
//    [self.refreshControl beginRefreshing];
//  } else {
//    [self.spinner startAnimating];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////    self.tableView.hidden = YES;
//  }
//  
//  NSURL *topPlacesURL = [FlickrFetcher URLforTopPlaces];
//  
//  // download off main thread
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    
//    // FETCH TOP PLACES
//    
//    // fetch the JSON data from Flickr
//    NSData *jsonData = [NSData dataWithContentsOfURL:topPlacesURL];
//    
//    // convert it to a Property List (NSArray and NSDictionary)
//    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
//    
//    // get the NSArray of place NSDictionarys out of the results
//    NSArray *places = [propertyListResults valueForKeyPath:@"places.place"];
//    
//    ///// create set of countries
//    NSMutableSet *countrySet = [NSMutableSet set];
//    
//    // print country order
//    for (NSDictionary *place in places) {
//      NSString *country = [place valueForKeyPath:@"_content"];
//      country = [[country componentsSeparatedByString:@","] lastObject];
//      [countrySet addObject:country];
//    }
//    
//    // order the countries
//    NSMutableArray *countriesArray = [[countrySet allObjects] mutableCopy];
//    NSArray *countryOrderedArray = [NSArray array];
//    countryOrderedArray = [countriesArray sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
//    
//    ///// create the places ordered list
//    NSMutableArray *placesSorted = [NSMutableArray array];
//    for (NSString *country in countryOrderedArray) {
//      [placesSorted addObject:[NSMutableArray array]];
//    }
//    
//    // add places to country sublists
//    for (NSDictionary *place in places) {
//      NSString *country = [place valueForKeyPath:@"_content"];
//      country = [[country componentsSeparatedByString:@","] lastObject];
//      NSUInteger countryIndex = [countryOrderedArray indexOfObject:country];
//      
//      NSMutableArray *subArray = [placesSorted objectAtIndex:countryIndex];
//      [subArray insertObject:place atIndex:0];
//    }
//    
//    // sort country sublists
//    for (NSMutableArray *array in placesSorted) {
//      
//      [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSString *country1 = [obj1 valueForKeyPath:@"_content"];
//        country1 = [[country1 componentsSeparatedByString:@","] lastObject];
//        NSString *country2 = [obj2 valueForKeyPath:@"_content"];
//        country2 = [[country2 componentsSeparatedByString:@","] lastObject];
//        return [country1 localizedCaseInsensitiveCompare:country2];
//      }];
//      
//    }
//    
//    sleep(5);
//    
//    // update the Model (and thus our UI), but do so back on the main queue
//    dispatch_async(dispatch_get_main_queue(), ^{
//      
//      // update the photos model
//      self.countries = countryOrderedArray;  // update first!
//      self.places = placesSorted;
//      
//    });
//  });
//}


//-(NSComparisonResult)comparePlace:(NSDictionary *)place {
//  // sort by name
//  int nameComp = [name compare:student.name];
//  if (nameComp != NSOrderedSame) return nameComp;
//  
//  // reverse ordered as desired in the question
//  if (grade > student.grade)
//    return NSOrderedAscending;
//  else if (grade == student.grade) // watchout here
//    return NSOrderedSame;
//  else
//    return NSOrderedDescending;
//}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.flickrFeed numItemsInFeed];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
  return [self.countries objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topPlaceCell"];
    
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topPlaceCell"];
  }
  
//  NSDictionary *place = [[self.places objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  FlickrPhotoObject *photo  = [self.flickrFeed itemAtIndex:indexPath.row];

  NSArray *components = [photo.country componentsSeparatedByString:@","];
  NSString *locality = [components firstObject];
  NSString *location = [components componentsJoinedByString:@" "]; 
  
  cell.textLabel.text = locality;
  cell.detailTextLabel.text = location;
  
  // configure cell using photo's metadata
  
//  cell.textLabel.text       = photo.country;
//  cell.detailTextLabel.text = photo.caption;
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
  FlickrPhotoObject *place = [self.flickrFeed itemAtIndex:indexPath.row];
  NSString *placeID = [place.dictionaryRepresentation valueForKeyPath:@"place_id"];
  NSURL *photosURL = [FlickrFetcher URLforPhotosInPlace:placeID maxResults:50];
  
  PlaceTableViewController *imgVC = [[PlaceTableViewController alloc] init];
  imgVC.flickrPlaceURL = photosURL;
  imgVC.resultsKeyPathString = FLICKR_RESULTS_PHOTOS;
  
  [self.navigationController pushViewController:imgVC animated:YES];
}

@end
