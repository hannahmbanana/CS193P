//
//  CustomTabBarController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController


#pragma mark - Superclass Method Extension

- (void)addChildViewController:(UIViewController *)childController
                     itemTitle:(NSString *)tabBarTitle
                 itemImageText:(NSString *)imageText
             itemImageTextSize:(CGFloat)size
{
  [super addChildViewController:childController];
  
  childController.tabBarItem = [self createTabBarItemWithTitle:tabBarTitle imageString:imageText stringFontSize:size];
}


#pragma mark - Helper Methods

// returns a UITabBarItem containing a vertically stacked image (top) and title (bottom)
- (UITabBarItem *)createTabBarItemWithTitle:(NSString *)title imageString:(NSString *)imageString stringFontSize:(NSUInteger)size
{
  // initialize tabBarItem & set title
  UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
  tabBarItem.title = title;
  
  // create UIImage from NSString & attributes
  NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:size]};
  NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:imageString attributes:attributes];
  CGSize textSize = [titleString size];
  UIImage *stringImage = [self imageFromNSString:imageString attributes:attributes size:textSize];
  
  // set tabBarItem image
  tabBarItem.image = stringImage;
  
  return tabBarItem;
}

// returns a UIImage of size, size, with text, string
- (UIImage *)imageFromNSString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

@end
