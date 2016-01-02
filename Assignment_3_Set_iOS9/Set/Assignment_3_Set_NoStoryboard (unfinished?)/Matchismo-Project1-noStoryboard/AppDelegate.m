//
//  AppDelegate.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "AppDelegate.h"
#import "CardGameViewController.h"
#import "SetGameViewController.h"
#import "CustomTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // FIXME: understand this stuff
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor colorWithRed:15/255.0 green:110/255.0
                                                   blue:48/255.0 alpha:1];
    
    CustomTabBarController *tabBarController = [[CustomTabBarController alloc] init];
    
    CardGameViewController *cardGameViewController = [[CardGameViewController alloc] init];
    
    UINavigationController *cardNavController = [[UINavigationController alloc] initWithRootViewController:cardGameViewController];
    
    [tabBarController addChildViewController:cardNavController
                             TabBarItemTitle:@"CARD MATCH"
                         TabBarItemImageText:@"♠︎ ♥︎"
                     TabBarItemImageTextSize:24];
    
    SetGameViewController *setGameViewController = [[SetGameViewController alloc] init];
    
    UINavigationController *setNavController = [[UINavigationController alloc] initWithRootViewController:setGameViewController];
    
    [tabBarController addChildViewController:setNavController
                             TabBarItemTitle:@"CLASSIC SET"
                         TabBarItemImageText:@"■ ▲"
                     TabBarItemImageTextSize:20];

    tabBarController.selectedViewController = setNavController;
    
    self.window.rootViewController = tabBarController;
    
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
