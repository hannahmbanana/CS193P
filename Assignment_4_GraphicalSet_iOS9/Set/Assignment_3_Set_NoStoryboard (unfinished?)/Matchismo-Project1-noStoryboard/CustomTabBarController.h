//
//  CustomTabBarController.h
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/19/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController

// override superclass
- (void)addChildViewController:(UIViewController *)childController
               TabBarItemTitle:(NSString *)tabBarTitle
           TabBarItemImageText:(NSString *)imageText
       TabBarItemImageTextSize:(CGFloat)size;

@end
