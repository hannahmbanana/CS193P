//
//  BlockingImageViewController.m
//  Imaginarium
//
//  Created by Hannah Troisi on 1/24/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "BlockingImageViewController.h"

@implementation BlockingImageViewController

+ (Class)imageViewClass
{
  return [BlockingImageViewController class];
}

- (void)startDownloadingImage
{
  self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imgURL]];
}

@end
