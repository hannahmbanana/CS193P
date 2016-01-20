//
//  CustomTabBarController.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController

// extends superclass' addChildViewController: method to create a custom UITabBarItem
- (void)addChildViewController:(UIViewController *)childController
                     itemTitle:(NSString *)tabBarTitle
                 itemImageText:(NSString *)imageText
             itemImageTextSize:(CGFloat)size;

@end
