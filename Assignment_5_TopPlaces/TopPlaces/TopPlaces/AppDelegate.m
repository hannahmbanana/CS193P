//
//  AppDelegate.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/2/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "AppDelegate.h"
#import "TopPlacesFlickrPhotosTVC.h"
#import "RecentsTableViewController.h"
#import "FlickrFetcher.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  // "Top Places" tableViewController
  TopPlacesFlickrPhotosTVC *topPlacesTVC = [[TopPlacesFlickrPhotosTVC alloc] initWithURL:[FlickrFetcher URLforTopPlaces]
                                                                                 resultsKeyPathString:FLICKR_RESULTS_PLACES];
  
  // "Top Places" tabBarItem
  UITabBarItem *topPlacesTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Top Places"
                                                                    image:[UIImage imageNamed:@"globe"]
                                                                      tag:0];
  
  // "Top Places" navigationController
  UINavigationController *topPlacesNavController = [[UINavigationController alloc] initWithRootViewController:topPlacesTVC];
  topPlacesNavController.tabBarItem = topPlacesTabBarItem;

  // "Recently Viewed" tableViewController
  RecentsTableViewController *recentlyViewedTVC = [[RecentsTableViewController alloc] initWithNibName:nil bundle:nil];
  
  // "Recently Viewed" tabBarItem
  UITabBarItem *recentlyViewedTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recents"
                                                                         image:[UIImage imageNamed:@"recents"]
                                                                           tag:1];
  
  // "Recently Viewed" navigationController
  UINavigationController *recentlyViewedNavController = [[UINavigationController alloc] initWithRootViewController:recentlyViewedTVC];
  recentlyViewedNavController.tabBarItem = recentlyViewedTabBarItem;

  // tabBarController
  UITabBarController *masterTabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
  masterTabBarController.viewControllers = @[topPlacesNavController, recentlyViewedNavController];
  
  // set the tabBarController's rootViewController to be the tabBarController (iPhone) or the splitViewController (iPad)
  UIUserInterfaceIdiom device = [[UIDevice currentDevice] userInterfaceIdiom];
  if (device == UIUserInterfaceIdiomPad) {

    // create a detailViewController
    UIViewController *detailVC                  = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    detailVC.view.backgroundColor               = [UIColor whiteColor];
    UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    // create a splitViewController
    UISplitViewController *svc = [[UISplitViewController alloc] init];
    
    // assign the splitViewController's master (0) and detail (1) viewControllers
    svc.viewControllers = @[masterTabBarController, detailNavController];
    
    // open app with masterViewController overlaid over detailViewController (detailViewController is empty on startup)
    svc.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
    
    // set the detailViewController's back button to get to the masterViewController when it's closed
    detailVC.navigationItem.leftBarButtonItem   = svc.displayModeButtonItem;
    
    // set the splitViewController to be the window's rootViewController
    self.window.rootViewController = svc;
    
  } else if (device == UIUserInterfaceIdiomPhone) {
    
    // set the tabBarController to be the window's rootViewController
    self.window.rootViewController = masterTabBarController;
    
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
