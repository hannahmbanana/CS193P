//
//  AppDelegate.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/2/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "AppDelegate.h"
#import "TopPlacesTableViewController.h"
#import "RecentsTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  // create "Top Places" tableViewController, wrap in a navController and add a tabBarItem
  TopPlacesTableViewController *topPlacesTVC      = [[TopPlacesTableViewController alloc] init];
  UINavigationController *topPlacesNavController  = [[UINavigationController alloc] initWithRootViewController:topPlacesTVC];
  UITabBarItem *topPlacesTabBarItem               = [[UITabBarItem alloc] initWithTitle:@"Top Places" image:nil tag:0];
  topPlacesNavController.tabBarItem               = topPlacesTabBarItem;

  // create "Recently Viewed" tableViewController, wrap in a navController and add a tabBarItem
  RecentsTableViewController *recentlyViewedTVC       = [[RecentsTableViewController alloc] init];
  UINavigationController *recentlyViewedNavController = [[UINavigationController alloc] initWithRootViewController:recentlyViewedTVC];
  UITabBarItem *recentlyViewedTabBarItem              = [[UITabBarItem alloc] initWithTitle:@"Recents" image:nil tag:1];
  recentlyViewedNavController.tabBarItem              = recentlyViewedTabBarItem;

  // create the tabBarController
  UITabBarController *tabBarController = [[UITabBarController alloc] init];
  tabBarController.viewControllers     = @[topPlacesNavController, recentlyViewedNavController];
  
  // set the rootViewController to be the tabBarController (iPhone) or the splitViewController (iPad)
  UIUserInterfaceIdiom device = [[UIDevice currentDevice] userInterfaceIdiom];
  if (device == UIUserInterfaceIdiomPad) {
    
    // iPad
    // create a splitViewController
    UISplitViewController *svc = [[UISplitViewController alloc] init];
    
    // create a detailViewController
    UIViewController *detailVC                  = [[UIViewController alloc] init];
    detailVC.navigationItem.leftBarButtonItem   = svc.displayModeButtonItem;
    UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    // assign the splitViewController's master (0) and detail (1) viewControllers
    svc.viewControllers = @[tabBarController, detailNavController];
    
    // set the splitViewController to be the window's rootViewController
    self.window.rootViewController = svc;
    
  } else if (device == UIUserInterfaceIdiomPhone) {
    
    // iPhone
    // set the tabBarController to be the window's rootViewController
    self.window.rootViewController = tabBarController;
    
  } else {
    
    // unsupported device
    NSLog(@"ERROR: do not recognizer UIUserInterfaceIdiom %lu", (long)device);
  }
  
  // show main window
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
