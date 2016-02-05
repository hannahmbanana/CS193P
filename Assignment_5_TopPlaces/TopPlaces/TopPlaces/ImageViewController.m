//
//  ImageViewController.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/3/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (nonatomic, strong, readwrite) UIImage      *image;
@property (nonatomic, strong, readwrite) UIImageView  *imageView;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@end

@implementation ImageViewController

#pragma mark - Properties

- (void)setImageURL:(NSURL *)imageURL
{
  _imageURL = imageURL;
  
  // start downloading image when imageURL is set
  [self startDownloadingImage];
}

- (void)setImage:(UIImage *)image
{
  _imageView.image = image;
  [_imageView sizeToFit];
  
  // update the scrollView's contentSize
  _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIImage *)image
{
  return _imageView.image;
}

- (UIImageView *)imageView
{
  // lazy instantiation
  if (!_imageView) {
    _imageView = [[UIImageView alloc] init];
  }
  return _imageView;
}

- (UIScrollView *)scrollView
{
  // lazy instantiation
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
  }
  return _scrollView;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.scrollView  addSubview:self.imageView];
  [self.view        addSubview:self.scrollView];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  self.scrollView.frame = self.view.bounds;
}

#pragma mark - Helper Methods

- (void)startDownloadingImage
{
  // remove old iamge before starting new download
  self.image = nil;
  
  // create NSURLSessionDownloadTask to download self.image off the main thread
  NSURLRequest *request                    = [NSURLRequest requestWithURL:self.imageURL];
  NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session                    = [NSURLSession sessionWithConfiguration:sessionConfig];
  NSURLSessionDataTask *task               = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    // check for errors downloading
    if (!error) {
      
      // check that downloaded image is still valid
      if (self.imageURL == request.URL) {
        
        // UIImage is okay off main thread
        UIImage *image = [UIImage imageWithData:data];
        
        // updated self.image on main thread (kicks off UI stuff)
        dispatch_async(dispatch_get_main_queue(), ^{
          self.image = image;
        });
      }
    }
  }];
  
  // task starts out suspended
  [task resume];
}


@end
