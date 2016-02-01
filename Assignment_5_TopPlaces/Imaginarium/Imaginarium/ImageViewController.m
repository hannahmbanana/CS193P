//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Hannah Troisi on 1/24/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@end

@implementation ImageViewController

#pragma mark - Class Methods

// SUBCLASS MUST IMPLEMENT
+ (Class)imageViewClass
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return Nil;
}


#pragma mark - Properties

- (void)setImgURL:(NSURL *)imgURL
{
  _imgURL = imgURL;
  [self startDownloadingImage];
}

// SUBCLASS MUST IMPLEMENT
- (void)startDownloadingImage
{
  NSAssert(NO, @"This should not be reached - abstract class");
}

- (UIImageView *)imageView
{
  if (!_imageView) {
    _imageView = [[UIImageView alloc] init];
  }
  return _imageView;
}

- (UIImage *)image
{
  return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
  [_spinner stopAnimating];
  
  self.imageView.image = image;
  
  // resize imageView
  [self.imageView sizeToFit];
  
  // set UIScrollView contentSize
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIScrollView *)scrollView
{
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.delegate = self;
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
  
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.imageView];
  [self.view addSubview:self.spinner];
}

- (void)viewWillLayoutSubviews
{
  self.scrollView.frame = self.view.bounds;
  
  [self.spinner sizeToFit];
  self.spinner.frame = CGRectMake((self.view.bounds.size.width - self.spinner.frame.size.width)/2,
                                  (self.view.bounds.size.height - self.spinner.frame.size.height)/2,
                                  self.spinner.frame.size.width,
                                  self.spinner.frame.size.height);
}

#pragma mark - UIScrollViewDelegate Methods

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.imageView;
}


@end
