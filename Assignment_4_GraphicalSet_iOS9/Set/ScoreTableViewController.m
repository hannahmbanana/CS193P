//
//  ScoreTableViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/9/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ScoreTableViewController.h"
#import "ScoreTableViewCell.h"


@implementation ScoreTableViewController
{
  NSMutableArray      *_gameDataArray;
  UISegmentedControl  *_tableHeaderSegControl;
}


#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super initWithStyle:UITableViewStylePlain];
  
  if (self) {
    // configure Nav title
    self.navigationItem.title = @"Score Board";
  }
  return self;
}

// put all view stuff in here so that it doesn't waste time making it until tab is selected
- (void)viewDidLoad
{
  // configure the UISegmentedControl
  NSArray *items = @[@"Score", @"Game", @"Duration", @"Date Played"];
  _tableHeaderSegControl = [[UISegmentedControl alloc] initWithItems:items];
  _tableHeaderSegControl.selectedSegmentIndex = 0;
  _tableHeaderSegControl.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.80];
  [_tableHeaderSegControl addTarget:self action:@selector(touchSegmentedControl:) forControlEvents:UIControlEventValueChanged];
  
  // set the UISegmentedControl to be the tableHeaderView
  self.tableView.tableHeaderView = _tableHeaderSegControl;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // set the UITableViewController's background to green
  self.view.backgroundColor = [UIColor colorWithRed:15/255.0 green:110/255.0 blue:48/255.0 alpha:1];
}

- (void)viewWillLayoutSubviews
{
  // set widths of UISegControl
  CGFloat width = self.tableView.bounds.size.width;
  [_tableHeaderSegControl setWidth:roundf(width * 1/6) forSegmentAtIndex:0];
  [_tableHeaderSegControl setWidth:roundf(width * 1/6) forSegmentAtIndex:1];
  [_tableHeaderSegControl setWidth:roundf(width * 2/6) forSegmentAtIndex:2];
  [_tableHeaderSegControl setWidth:roundf(width * 2/6) forSegmentAtIndex:3];
  
  // set frame for tableHeaderView
  self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 35);
}

- (void)viewWillAppear:(BOOL)animated
{
  // get gameDataArray from NSUserDefaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  _gameDataArray = [[defaults objectForKey:@"gameDataArray"] mutableCopy];
  
  [self.tableView reloadData];
}

#pragma mark - Sorting

- (void)touchSegmentedControl:(UISegmentedControl *)segControl
{
  NSString *selectedSegTitle = [segControl titleForSegmentAtIndex:segControl.selectedSegmentIndex];
  
  if ( [selectedSegTitle isEqualToString:@"Game"] ) {
    
    [self sortDataByGame];
    
  } else if ( [selectedSegTitle isEqualToString:@"Date Played"] ) {
    
    [self sortDataByDate];
    
  } else if ( [selectedSegTitle isEqualToString:@"Duration"] ) {
    
    [self sortDataByDuration];
    
  } else if ( [selectedSegTitle isEqualToString:@"Score"] ) {
    
    [self sortDataByScore];
    
  }
  
  // reload the tableView
  [self.tableView reloadData];
}

- (void)sortDataByGame
{
  [_gameDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    NSString *string1 = [obj1 objectForKey:@"gameType"];
    NSString *string2 = [obj2 objectForKey:@"gameType"];
    return [string1 compare:string2 options:NSNumericSearch];
  }];
}

- (void)sortDataByDate
{
  [_gameDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    NSDate *date1 = [obj1 objectForKey:@"start"];
    NSDate *date2 = [obj2 objectForKey:@"start"];
    return [date2 compare:date1];
  }];
}

- (void)sortDataByDuration
{
  [_gameDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    NSTimeInterval interval1 = [[obj1 objectForKey:@"end"] timeIntervalSinceDate:[obj1 objectForKey:@"start"]];
    NSTimeInterval interval2 = [[obj2 objectForKey:@"end"] timeIntervalSinceDate:[obj2 objectForKey:@"start"]];

    if ( interval1 < interval2 ) {
      return (NSComparisonResult)NSOrderedAscending;
    } else if ( interval1 > interval2 ) {
      return (NSComparisonResult)NSOrderedDescending;
    }
    return (NSComparisonResult)NSOrderedSame;
  }];
}

- (void)sortDataByScore
{
  [_gameDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    NSInteger score1 = [[obj1 objectForKey:@"score"] integerValue];
    NSInteger score2 = [[obj2 objectForKey:@"score"] integerValue];
    
    if ( score1 < score2 ) {
      return (NSComparisonResult)NSOrderedDescending;
    } else if ( score1 > score2 ) {
      return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
  }];
}


#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_gameDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ScoreTableViewCell *cell = [[ScoreTableViewCell alloc] initWithDictionary:_gameDataArray[indexPath.row]];

  return cell;
}

@end
