//
//  ImageViewController.h
//  Imaginarium
//
//  Created by Hannah Troisi on 1/24/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//


// ABSTRACT CLASS
#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong, readwrite) NSURL                    *imgURL;      // URL of the image to display

// SUBCLASS MUST IMPLEMENT
- (void)startDownloadingImage;

@end
