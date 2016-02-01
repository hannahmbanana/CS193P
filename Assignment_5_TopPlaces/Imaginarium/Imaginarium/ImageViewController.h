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

@property (nonatomic, strong, readwrite) NSURL                    *imgURL;
@property (nonatomic, strong, readwrite) UIImageView              *imageView;
@property (nonatomic, strong, readwrite) UIImage                  *image;
@property (nonatomic, strong, readwrite) UIScrollView             *scrollView;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView  *spinner;

// SUBCLASS MUST IMPLEMENT
+ (Class)imageViewClass;

// SUBCLASS MUST IMPLEMENT
- (void)startDownloadingImage;

@end
