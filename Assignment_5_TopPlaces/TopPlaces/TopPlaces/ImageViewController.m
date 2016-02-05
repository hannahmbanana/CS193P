//
//  ImageViewController.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/3/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong, readwrite) UIImage                  *image;
@property (nonatomic, strong, readwrite) UIImageView              *imageView;
@property (nonatomic, strong, readwrite) UIScrollView             *scrollView;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView  *spinner;
@end

@implementation ImageViewController


#pragma mark - Properties

- (void)setImageURL:(NSURL *)imageURL
{
  _imageURL = imageURL;
  
  // start downloading the image when imageURL is set
  [self startDownloadingImage];
}

- (void)setImage:(UIImage *)image
{
  self.imageView.image = image;
  
  // resize the imageView to fit its new image
  [_imageView sizeToFit];
  
  // set scrollView's contentSize
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
  
  // stop spinner animation
  [self.spinner stopAnimating];
}

- (UIImage *)image
{
  return self.imageView.image;
}

- (UIImageView *)imageView
{
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
    
    // necessary for zooming
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 1.2;
    
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;  // size is a struct! cannot message nil and rely on a structure return value!
  }
  return _scrollView;
}

- (UIActivityIndicatorView *)spinner
{
  if (!_spinner) {
    _spinner = [[UIActivityIndicatorView alloc] init];
    _spinner.color = [UIColor darkGrayColor];
    _spinner.hidesWhenStopped = YES;
  }
  return _spinner;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self.scrollView  addSubview:self.imageView];
  [self.view        addSubview:self.scrollView];
  [self.view        addSubview:self.spinner];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  CGRect visibleRect   = self.view.bounds;
  CGFloat navBarBottom = CGRectGetMaxY(self.navigationController.navigationBar.frame);
  CGFloat tabBarBottom = CGRectGetHeight(self.tabBarController.tabBar.frame);
  
  // scrollView
  self.scrollView.frame = visibleRect;
  self.scrollView.contentInset = UIEdgeInsetsMake(navBarBottom, 0, tabBarBottom, 0);
  
  // spinner
  [self.spinner sizeToFit];
  
  CGSize spinnerSize = self.spinner.frame.size;
  self.spinner.frame = CGRectMake((visibleRect.size.width - spinnerSize.width)/2,
                                  (visibleRect.size.height - spinnerSize.height)/2,
                                  spinnerSize.width,
                                  spinnerSize.height);
}


#pragma mark - Helper Methods

- (void)startDownloadingImage
{
  // clear the imageView's image when we start downloading a new one
  self.image = nil;
  
  // if we have an image URL to download
  if (self.imageURL) {
    
    // start the spinner animation
    [self.spinner startAnimating];
    
    // create the NSURLSessionDownloadTask (asynchronous) to download self.imgURL off the main thread
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
            
            // set self.image to be newly downloaded picture
            self.image = image;
            
            // set zoom to make picture fill the screen
            [self setZoom];
          });
        }
        
      } else {
        NSLog(@"Error: %@", error);
      }
      
    }];  // end of completion handler
    
    // start the NSURLSessionDownloadTask (starts out suspended)
    [task resume];
  }
}

- (void)setZoom
{
# warning Not finished
  // set zoom to show as much of the photo as possible with no extra, unused space
//  __block CGRect zoomRect = CGRectMake(0,
//                                       0, //self.scrollView.contentInset.top,
//                                       self.view.bounds.size.width,
//                                       self.imageView.bounds.size.height);
//
//  [_scrollView zoomToRect:zoomRect animated:NO];
  
//  [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
//    visibleRectMinusNavBar.origin.x += self.imageView.bounds.size.width - _scrollView.bounds.size.width;
//    _scrollView.contentOffset = visibleRectMinusNavBar.origin;
//  } completion:^(BOOL finished) {}];
  
//  [_scrollView setContentMode:UIViewContentModeScaleAspectFit];

}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  // return view to zooom
  return self.imageView;
}


@end
