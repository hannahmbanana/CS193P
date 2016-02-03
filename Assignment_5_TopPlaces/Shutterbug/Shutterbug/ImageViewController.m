//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Hannah Troisi on 1/24/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong, readwrite) UIImageView              *imageView;
@property (nonatomic, strong, readwrite) UIImage                  *image;
@property (nonatomic, strong, readwrite) UIScrollView             *scrollView;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView  *spinner;
@end

@implementation ImageViewController

#pragma mark - Properties

- (void)setImgURL:(NSURL *)imgURL
{
  _imgURL = imgURL;
  [self startDownloadingImage];
}

- (UIImageView *)imageView
{
  if (!_imageView) {
    _imageView = [[UIImageView alloc] init];
  }
  return _imageView;
}

// image property does not use an _image instance variable
// instead it just reports/sets the image in the imageView property
// thus we don't need @synthesize even though we implement both setter and getter
- (UIImage *)image
{
  return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
  self.imageView.image = image;  // does not change the frame of the UIImageView
  
  // resize imageView
  [self.imageView sizeToFit];
  
  // set UIScrollView contentSize
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
  
  // stop spinner animation
  [_spinner stopAnimating];
}

- (UIScrollView *)scrollView
{
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] init];
    
    // necessary for zooming
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.delegate = self;
    
     self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
  }
  return _scrollView;
}

- (UIActivityIndicatorView *)spinner
{
  if (!_spinner) {
    _spinner = [[UIActivityIndicatorView alloc] init];
    _spinner.hidesWhenStopped = YES;
    _spinner.color = [UIColor blueColor];
  }
  return _spinner;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  // add subviews
  [self.scrollView  addSubview:self.imageView];
  [self.view        addSubview:self.scrollView];
  [self.view        addSubview:self.spinner];
}

- (void)viewWillLayoutSubviews
{
  // scrollView
  self.scrollView.frame = self.view.bounds;
  
  // spinner
  [self.spinner sizeToFit];
  self.spinner.frame = CGRectMake((self.view.bounds.size.width - self.spinner.frame.size.width)/2,
                                  (self.view.bounds.size.height - self.spinner.frame.size.height)/2,
                                  self.spinner.frame.size.width,
                                  self.spinner.frame.size.height);
}


#pragma mark - Helper Methods

- (void)startDownloadingImage
{
  // clear the imageView's image when we start downloading a new one
  self.image = nil;
  
  // if we have an image URL to download
  if (self.imgURL) {
    
    // start the spinner animation
    [self.spinner startAnimating];
    
    // create the NSURLSessionDownloadTask (asynchronous) to download self.imgURL off the main thread
    NSURLRequest *request                     = [NSURLRequest requestWithURL:self.imgURL];
    NSURLSessionConfiguration *sessionConfig  = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    // create the session without specifying a queue to run completion handler on
    NSURLSession *session                     = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDownloadTask *task            = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
      if (!error) {
        
        // check that the url we just downloaded is still valid
        if (self.imgURL == request.URL) {
          
          // create a UIImage with the response (UIImage can be done off the main thread)
          UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
          
          // this completion handler is not executing on the main thread, so we must dispatch UI work back to the main thread
          dispatch_async( dispatch_get_main_queue(), ^{ self.image = image; });
        }
        
      } else {
        NSLog(@"Error: %@", error);
      }
      
    }]; // end of completion handler
    
    // start the NSURLSessionDownloadTask (starts out suspended)
    [task resume];
  }
}


#pragma mark - UIScrollViewDelegate Methods

// mandatory zooming method
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.imageView;
}


@end
