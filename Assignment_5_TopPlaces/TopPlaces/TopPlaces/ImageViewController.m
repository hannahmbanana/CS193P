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
  
  // clear the imageView's image when we start downloading a new one
  self.image = nil;
  
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
    _imageView.layer.borderWidth = 30;
    _imageView.layer.borderColor = [[UIColor redColor] CGColor];
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
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    
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
  
  CGRect bounds = self.view.bounds;
  
  // scrollView
  _scrollView.frame = bounds;
  
  // spinner
  [_spinner sizeToFit];
  
  CGRect spinnerFrame = _spinner.frame;
  spinnerFrame.origin = CGPointMake((bounds.size.width - spinnerFrame.size.width) / 2.0,
                                    (bounds.size.height - spinnerFrame.size.height) / 2.0);
  _spinner.frame = spinnerFrame;
  
  [self setZoom];
}

- (void)viewWillDisappear:(BOOL)animated
{
  // cancel any remaining download tasks
}

#pragma mark - Helper Methods

- (void)startDownloadingImage
{
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
            [self.view setNeedsLayout];
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
  if (!_imageView.image) {
    return;
  }
  
  // set zoom to show as much of the photo as possible with no extra, unused space
  
  // content inset adds buffer to scrollView contentSize
  // content offset is x,y position of upperleft
  
  CGSize imageSize = _imageView.image.size;
  CGSize boundsSize = _scrollView.bounds.size;

  UIEdgeInsets contentInset = _scrollView.contentInset;
  CGSize visibleSize = CGSizeMake(boundsSize.width, boundsSize.height - contentInset.top - contentInset.bottom);
  
  CGFloat imageAspectRatio = imageSize.width / imageSize.height;
  CGFloat visibleAspectRatio = visibleSize.width / visibleSize.height;
  BOOL imageIsPortraitRelativeToBounds = (imageAspectRatio < visibleAspectRatio);
  
  CGFloat zoomScaleToFill = 1.0;
  
  // scrollView zoom auto centers picture in scroll so we need to do contentOffsets to get it to start at (0,0)
  CGPoint startContentOffset = CGPointZero;
  CGPoint endContentOffset   = CGPointZero;

  if ( imageIsPortraitRelativeToBounds ) {
    zoomScaleToFill    = visibleSize.width / imageSize.width;
    startContentOffset = CGPointMake(0, imageSize.height * zoomScaleToFill - boundsSize.height + contentInset.bottom);
    endContentOffset   = CGPointMake(0, -contentInset.top);
  } else {
    zoomScaleToFill    = visibleSize.height / imageSize.height;
    startContentOffset = CGPointMake(0, -contentInset.top);
    endContentOffset   = CGPointMake(imageSize.width * zoomScaleToFill - boundsSize.width, -contentInset.top);
  }
  
  _scrollView.zoomScale = zoomScaleToFill;
  _scrollView.contentOffset = startContentOffset;

  [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    _scrollView.contentOffset = endContentOffset;
  } completion:^(BOOL finished) {}];
}

- (void)cancelScrollAnimation
{
  CALayer *presentationLayer = _scrollView.layer.presentationLayer;
  CGPoint currentContentOffset = presentationLayer.bounds.origin;
  [_scrollView.layer removeAllAnimations];
  _scrollView.contentOffset = currentContentOffset;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self cancelScrollAnimation];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view
{
  [self cancelScrollAnimation];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  // return view to zooom
  return _imageView;
}


@end
