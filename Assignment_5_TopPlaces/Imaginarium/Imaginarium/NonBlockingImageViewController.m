//
//  NonBlockingImageViewController.m
//  Imaginarium
//
//  Created by Hannah Troisi on 1/24/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "NonBlockingImageViewController.h"

@implementation NonBlockingImageViewController

+ (Class)imageViewClass
{
  return [NonBlockingImageViewController class];
}

- (void)startDownloadingImage
{
  self.image = nil;
  
  if (self.imgURL) {
    
    [self.spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imgURL];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
      if (!error) {
        if (self.imgURL == request.URL) {
          
          // UIImage can be done off the main thread
          UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
          
          // setting self.image must be done on the main thread because it causes UI updates in code below
          dispatch_async( dispatch_get_main_queue(), ^{ self.image = image; });
        }
      } else {
        NSLog(@"Error: could not find photo.");
      }
                        
    }];
    
    [task resume];
  }
}

@end
