//
//  CustomTabBarController.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/19/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController

#pragma mark - Lifecycle

- (void)addChildViewController:(UIViewController *)childController
               TabBarItemTitle:(NSString *)tabBarTitle
           TabBarItemImageText:(NSString *)imageText
       TabBarItemImageTextSize:(CGFloat)size
{
    [super addChildViewController:childController];
    
    childController.tabBarItem = [self createTabBarItemWithTitle:tabBarTitle
                                                     ImageString:imageText
                                                  StringFontSize:size];
}

#pragma mark - Helper Methods

- (UITabBarItem *)createTabBarItemWithTitle:(NSString *)title
                                ImageString:(NSString *)imageString
                             StringFontSize:(NSUInteger)size
{
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    
    NSDictionary *attributes =
    @{NSFontAttributeName : [UIFont systemFontOfSize:size],
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSBackgroundColorAttributeName : [UIColor clearColor]};
    
    NSAttributedString *titleString =
    [[NSAttributedString alloc] initWithString:imageString
                                    attributes:attributes];
    
    CGSize textSize = [titleString size];
    
    UIImage *stringImage = [self imageFromString:imageString
                                      attributes:attributes
                                            size:textSize];
    
    tabBarItem.title = title;
    tabBarItem.image = stringImage;
    
    return tabBarItem;
}

- (UIImage *)imageFromString:(NSString *)string
                  attributes:(NSDictionary *)attributes
                        size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height)
        withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
