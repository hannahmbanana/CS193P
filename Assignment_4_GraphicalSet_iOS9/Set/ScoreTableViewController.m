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
    
    // configure Navigation items
    self.navigationItem.title = @"Score Board";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clearScoreBoard)];
  }
  return self;
}

// put all view stuff in here so that it doesn't waste time making it until tab is selected
- (void)viewDidLoad
{
  // configure tableView
  self.tableView.scrollEnabled = NO;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [UIColor clearColor];
  
  // configure the UISegmentedControl
  _tableHeaderSegControl = [[UISegmentedControl alloc] initWithItems:@[@"Score", @"Game", @"Duration", @"Date Played"]];
  _tableHeaderSegControl.selectedSegmentIndex = 0;
  
  // target action pair for selecting segments
  [_tableHeaderSegControl addTarget:self action:@selector(touchSegmentedControl:) forControlEvents:UIControlEventValueChanged];
  
  // change appearance of SegmentedControl to have square corners
  UIEdgeInsets insets = UIEdgeInsetsMake(2, 2, 2, 2);
  
  // create resizableImage - one filled, one not
  UIImage *assetImage1 = [[[self resizeableSquareImageWithFill:NO] resizableImageWithCapInsets:insets]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  UIImage *assetImage2 = [[[self resizeableSquareImageWithFill:YES] resizableImageWithCapInsets:insets]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  [[UISegmentedControl appearance] setBackgroundImage:assetImage1 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  [[UISegmentedControl appearance] setBackgroundImage:assetImage2 forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
  
  // set the UISegmentedControl to be the tableHeaderView
  self.tableView.tableHeaderView = _tableHeaderSegControl;
  self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];  // matches Nav color
}

- (void)viewWillLayoutSubviews
{
  // set widths of UISegControl
  CGFloat boundsWidth = self.tableView.bounds.size.width;
  
  [_tableHeaderSegControl setWidth:roundf(boundsWidth * 1/6) forSegmentAtIndex:0];
  [_tableHeaderSegControl setWidth:roundf(boundsWidth * 1/6) forSegmentAtIndex:1];
  [_tableHeaderSegControl setWidth:roundf(boundsWidth * 2/6) forSegmentAtIndex:2];
  [_tableHeaderSegControl setWidth:roundf(boundsWidth * 2/6) forSegmentAtIndex:3];
  
  // set frame for tableHeaderView
  self.tableView.tableHeaderView.frame = CGRectMake(0, 0, boundsWidth, 30);
}

- (void)viewWillAppear:(BOOL)animated
{
  [self updateScoreBoard];
}


#pragma mark - Helper Methods

- (void)updateScoreBoard
{
  // get gameDataArray from NSUserDefaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  _gameDataArray = [[defaults objectForKey:@"gameDataArray"] mutableCopy];
  
  // reload data
  [self.tableView reloadData];
}

- (void)clearScoreBoard
{
  // reset NSUserDefaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:@"gameDataArray"];
  
  [self updateScoreBoard];
}

- (UIImage *)resizeableSquareImageWithFill:(BOOL)fill
{
  CGSize size = CGSizeMake(5,5);
  CGRect rect = (CGRect){ CGPointZero, size };
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
  path.lineWidth = 3;
  [path stroke];
  
  if (fill) {
    [[UIColor whiteColor] set];
    [path fill];
  }
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
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
