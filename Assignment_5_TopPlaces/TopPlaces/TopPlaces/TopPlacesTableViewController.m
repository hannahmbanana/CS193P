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

@interface TopPlacesTableViewController ()
@property (nonatomic, strong, readwrite) NSArray *places;
@property (nonatomic, strong, readwrite) NSArray *countries;
@end

@implementation TopPlacesTableViewController

# pragma mark - Properties

- (void)setPlaces:(NSArray *)places
{
  _places = places;
  
  // whenever our model is updated, reload the data table
  [self.tableView reloadData];
}

# pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title = @"Top Places";
  
  // add the spinner
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(fetchFlickrTopPlaces) forControlEvents:UIControlEventValueChanged];
  
  // fetchTopPlaces
  [self fetchFlickrTopPlaces];    // QUESTION: why is this the best lifecycle method to put this in?
}


#pragma mark - Helper Methods

- (void)fetchFlickrTopPlaces
{
  // start the spinner animation
  [self.refreshControl beginRefreshing];
  
  NSURL *topPlacesURL = [FlickrFetcher URLforTopPlaces];
  
  // download off main thread
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // FETCH TOP PLACES
    
    // fetch the JSON data from Flickr
    NSData *jsonData = [NSData dataWithContentsOfURL:topPlacesURL];
    
    // convert it to a Property List (NSArray and NSDictionary)
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    // get the NSArray of place NSDictionarys out of the results
    NSArray *places = [propertyListResults valueForKeyPath:@"places.place"];
    
//    NSLog(@"places = %@", places);
    
//    NSMutableArray *placeIDList = [NSMutableArray array];
//    for (NSDictionary *place in places) {
//      
//      NSString *placeID = [place valueForKeyPath:@"place_id"];
//      NSURL *placeURL = [FlickrFetcher URLforInformationAboutPlace:placeID];
//      NSData *placeJsonData = [NSData dataWithContentsOfURL:placeURL];
//      NSDictionary *placePropertyListResults = [NSJSONSerialization JSONObjectWithData:placeJsonData options:0 error:NULL];
//
//      [placeIDList addObject:placePropertyListResults];
//    }
    
    
    ///// create set of countries
    NSMutableSet *countrySet = [NSMutableSet set];
    
    // print country order
    for (NSDictionary *place in places) {
      NSString *country = [place valueForKeyPath:@"_content"];
      country = [[country componentsSeparatedByString:@","] lastObject];
      [countrySet addObject:country];
    }
    
    // order the countries
    NSMutableArray *countriesArray = [[countrySet allObjects] mutableCopy];
    NSArray *countryOrderedArray = [NSArray array];
    countryOrderedArray = [countriesArray sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
    
    ///// create the places ordered list
    NSMutableArray *placesSorted = [NSMutableArray array];
    for (NSString *country in countryOrderedArray) {
      [placesSorted addObject:[NSMutableArray array]];
    }
    
    // add places to country sublists
    for (NSDictionary *place in places) {
      NSString *country = [place valueForKeyPath:@"_content"];
      country = [[country componentsSeparatedByString:@","] lastObject];
      NSUInteger countryIndex = [countryOrderedArray indexOfObject:country];
      
      NSMutableArray *subArray = [placesSorted objectAtIndex:countryIndex];
      [subArray insertObject:place atIndex:0];
    }
    
    // sort country sublists
    for (NSMutableArray *array in placesSorted) {
      
      [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *country1 = [obj1 valueForKeyPath:@"_content"];
        country1 = [[country1 componentsSeparatedByString:@","] lastObject];
        NSString *country2 = [obj2 valueForKeyPath:@"_content"];
        country2 = [[country2 componentsSeparatedByString:@","] lastObject];
        return [country1 localizedCaseInsensitiveCompare:country2];
      }];
      
    }

    
    
    // update the Model (and thus our UI), but do so back on the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
      
      // stop the spinner animation
      [self.refreshControl endRefreshing];
      
      // update the photos model
      self.countries = countryOrderedArray;  // update first!
      self.places = placesSorted;
      
      
    });
  });
}


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
  return [[self.places objectAtIndex:section] count];
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
  
  NSDictionary *place = [[self.places objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  NSArray *components = [[place valueForKeyPath:@"_content"] componentsSeparatedByString:@","];
  NSString *locality = [components firstObject];
  NSString *location = [components componentsJoinedByString:@" "];
  
  cell.textLabel.text = locality;
  cell.detailTextLabel.text = location;
  
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *place = [[self.places objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  NSString *placeID = [place valueForKeyPath:@"place_id"];
  NSURL *photosURL = [FlickrFetcher URLforPhotosInPlace:placeID maxResults:50];
  
  PlaceTableViewController *imgVC = [[PlaceTableViewController alloc] init];
  imgVC.flickrPlaceURL = photosURL;
  
  [self.navigationController pushViewController:imgVC animated:YES];
}

@end
