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
@property (nonatomic, strong, readwrite) NSURLSessionDataTask     *task;
@end

@implementation ImageViewController


#pragma mark - Properties

- (void)setImageURL:(NSURL *)imageURL
{
  // check that our imageURL is the same, an image has been loaded (presumably for that URL)
  if ( _imageURL && [imageURL isEqual:_imageURL] && self.image ) {
    return;
  }
  
  _imageURL = imageURL;
  
  // clear the imageView's image
  self.image = nil;
  
  [self startDownloadingImage];
}

- (void)setImage:(UIImage *)image
{
  self.imageView.image = image;
  
  [self.view setNeedsLayout];
}

- (UIImage *)image
{
  return self.imageView.image;
}

- (UIImageView *)imageView
{
  if (!_imageView) {
    _imageView = [[UIImageView alloc] init];
    
    // debug
    //_imageView.layer.borderWidth = 30;
    //_imageView.layer.borderColor = [[UIColor redColor] CGColor];
  }
  return _imageView;
}

- (UIScrollView *)scrollView
{
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] init];

    // necessary for zooming
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.alwaysBounceHorizontal = YES;
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
  
  // resize the imageView to fit its new image
  _imageView.frame = (CGRect) {CGPointZero, self.image.size};
  
  // scrollView layout
  _scrollView.frame = bounds;
  
  // must reset zoomScale before updating scrollView's contentSize - zoomScale affects the contentSize!!!
  self.scrollView.zoomScale = 1.0;

  // set scrollView's contentSize
  // this is the best practice for structures - cannot message nil and rely on a structure to return a good value!
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
  
  // spinner layout
  [_spinner sizeToFit];
  CGRect spinnerFrame = _spinner.frame;
  spinnerFrame.origin = CGPointMake((bounds.size.width - spinnerFrame.size.width) / 2.0,
                                    (bounds.size.height - spinnerFrame.size.height) / 2.0);
  _spinner.frame = spinnerFrame;
  
  // set zoomScale to show as much of the photo as possible in the scrollView
  [self setZoomScale];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  // cancel any download tasks
  [self.task cancel];
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
    self.task                                = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
      // check for errors downloading
      if (!error) {
        
        // check that downloaded image is still valid
        if (self.imageURL == request.URL) {
          
          // UIImage is okay off main thread
          UIImage *image = [UIImage imageWithData:data];
          
          // updated self.image on main thread (kicks off UI stuff)
          dispatch_async(dispatch_get_main_queue(), ^{
            
            // stop spinner animation
            [self.spinner stopAnimating];
            
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
    [self.task resume];
  }
}

// set scrollView's zoomScale to show as much of the photo as possible with no extra, unused space
- (void)setZoomScale
{
  // okay stylistically to early return if at top of method
  if (!_imageView.image) {
    return;
  }
  
  CGSize imageSize          = _imageView.image.size;
  CGSize boundsSize         = _scrollView.bounds.size;
  
  // contentInset adds buffer to scrollView contentSize
  UIEdgeInsets contentInset = _scrollView.contentInset;
  CGSize visibleSize        = CGSizeMake(boundsSize.width, boundsSize.height - contentInset.top - contentInset.bottom);
  
  CGFloat imageAspectRatio              = imageSize.width / imageSize.height;
  CGFloat visibleAspectRatio            = visibleSize.width / visibleSize.height;
  BOOL imageIsPortraitRelativeToBounds  = (imageAspectRatio < visibleAspectRatio);
  
  CGFloat zoomScaleToFill = 1.0;
  
  // scrollView auto centers scrollView content vertically (if vertical scroll only) - so we need to use
  // contentOffsets to get it to start at (0,0). Content offset is x,y position of upper left corner of image
  CGPoint startContentOffset = CGPointZero;
  CGPoint endContentOffset   = CGPointZero;

  // set zoomScale depending on image aspect ratio & visible screen aspect ratio
  if ( imageIsPortraitRelativeToBounds ) {
    
    // portrait
    zoomScaleToFill    = visibleSize.width / imageSize.width;

    // animate a slow pan left to right
    startContentOffset = CGPointMake(0, imageSize.height * zoomScaleToFill - boundsSize.height + contentInset.bottom);
    endContentOffset   = CGPointMake(0, -contentInset.top);
    
  } else {
    
    // landscape
    zoomScaleToFill    = visibleSize.height / imageSize.height;
    
    // animate a slow pan bottom to top
    startContentOffset = CGPointMake(0, -contentInset.top);
    endContentOffset   = CGPointMake(imageSize.width * zoomScaleToFill - boundsSize.width, -contentInset.top);
  }
  
  // set scrollView's zoomScale & contentOffset
  _scrollView.zoomScale     = zoomScaleToFill;
  _scrollView.contentOffset = startContentOffset;

  // animate a slow pan with parameters set above
  [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    _scrollView.contentOffset = endContentOffset;
  } completion:^(BOOL finished) {}];
}

- (void)cancelScrollAnimation
{
  // presentation layer has actual contentOffset values of animation
  CALayer *presentationLayer    = _scrollView.layer.presentationLayer;
  CGPoint currentContentOffset  = presentationLayer.bounds.origin;
  
  // remove all animations in process
  [_scrollView.layer removeAllAnimations];
  
  // set scrollView's contentOffset to animation's currentOffset
  _scrollView.contentOffset = currentContentOffset;
}


#pragma mark - UIScrollViewDelegate

// cancel animation when user begins to pan
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self cancelScrollAnimation];
}

// cancel animation when user begins to zoom
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view
{
  [self cancelScrollAnimation];
}

// return view to zooom
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _imageView;
}


@end
