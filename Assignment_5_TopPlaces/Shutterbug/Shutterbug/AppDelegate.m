//
//  AppDelegate.m
//  Shutterbug
//
//  Created by Hannah Troisi on 2/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "AppDelegate.h"
#import "JustPostedFlickrPhotosTVC.h"
#import "ImageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  // create the photos tableViewController & wrap it in a NavController
  JustPostedFlickrPhotosTVC *tvc            = [[JustPostedFlickrPhotosTVC alloc] init];
  UINavigationController *tvcNavController  = [[UINavigationController alloc] initWithRootViewController:tvc];
  
  // is the app running on an iPad?
  BOOL iPad = ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad );
  
  // set the window's rootViewController
  if (iPad) {
    
    // if the app is running on an iPad, create a splitViewController
    UISplitViewController *svc = [[UISplitViewController alloc] init];
    
    // create the detailViewController & wrap it in a NavController
    ImageViewController *detailVC    = [[ImageViewController alloc] init];
    UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:detailVC];

    // add the masterViewController is hidden back button to the detailViewController
    detailVC.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    
    // set the splitViewController's master and detail viewControllers
    svc.viewControllers = @[tvcNavController, detailNavController];
    
    // (iPad) set the splitViewController to be the window's rootViewController
    self.window.rootViewController = svc;
    
  } else {
    
    // (iPhone) set the photos tableViewController as the window's rootViewController
    self.window.rootViewController = tvcNavController;
  }
  
  // show main window and make it key
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
