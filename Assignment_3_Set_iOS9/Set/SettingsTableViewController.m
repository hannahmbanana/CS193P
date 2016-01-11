//
//  SettingsTableViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController


#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  
  if (self) {
    // configure Nav title
    self.navigationItem.title = @"Settings";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return self;
}

// put all view stuff in here so that it doesn't waste time making it until tab is selected
- (void)viewDidLoad
{
  // set the UITableViewController's background to green
  self.view.backgroundColor = [UIColor colorWithRed:15/255.0 green:110/255.0 blue:48/255.0 alpha:1];
}

- (void)viewWillLayoutSubviews
{
  
  // set frame for tableHeaderView
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  if (indexPath.row == 0) {
    
    // reset NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"gameDataArray"];
    
    // unselect row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}

#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  
  if (indexPath.row == 0) {
    
    cell.textLabel.text = @"Reset Scoreboard";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.80];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
  }
  return cell;
}

@end
