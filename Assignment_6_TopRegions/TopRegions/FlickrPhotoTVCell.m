//
//  FlickrPhotoTVCell.m
//  TopPlaces
//
//  Created by Hannah Troisi on 2/7/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "FlickrPhotoTVCell.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTVCell ()
@property(nonatomic, strong, readwrite) UIImageView *thumbnailImageView;
@property(nonatomic, strong, readwrite) UILabel     *title;
@property(nonatomic, strong, readwrite) UILabel     *caption;
@end

@implementation FlickrPhotoTVCell


#pragma mark - Class Methods

+ (NSString *)reuseIdentifier
{
  return @"flickrPhotoTVCell";
}


#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(FlickrPhotoObject *)photo;
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"flickrPhotoTVCell"];
  
  if (self) {
    self.title = [[UILabel alloc] init];
    self.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.caption = [[UILabel alloc] init];
    self.caption.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    self.thumbnailImageView = [[UIImageView alloc] init];
    
    [self updateCellWithPhoto:photo];
  }
  return self;
}

#define THUMBNAIL_IMAGE_INSET 3
#define TEXT_INSET 30
- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGSize boundSize = self.bounds.size;
  
  // thumbnail layout
  self.thumbnailImageView.frame = CGRectMake(THUMBNAIL_IMAGE_INSET,
                                             THUMBNAIL_IMAGE_INSET,
                                             boundSize.height - 2 * THUMBNAIL_IMAGE_INSET,
                                             boundSize.height - 2 * THUMBNAIL_IMAGE_INSET);
  
  [self.contentView addSubview:self.thumbnailImageView];

  // title layout
  [self.title sizeToFit];
  CGFloat textLeftInset = CGRectGetMaxX(self.thumbnailImageView.frame) + THUMBNAIL_IMAGE_INSET;
  self.title.frame = CGRectMake(textLeftInset,
                                TEXT_INSET,
                                self.title.frame.size.width,
                                self.title.frame.size.height);

  [self.contentView addSubview:self.title];

  // caption layout
  [self.caption sizeToFit];
  self.caption.frame = CGRectMake(textLeftInset,
                                  boundSize.height - TEXT_INSET - self.caption.frame.size.height,
                                  self.caption.frame.size.width,
                                  self.caption.frame.size.height);

  [self.contentView addSubview:self.caption];
}

#pragma mark - Helper Methods

- (void)updateCellWithPhoto:(FlickrPhotoObject *)photo;
{
  // download thumbnail image
  [self downloadThumbnailImage:photo];
  
  // set title, caption text
  NSString *title   = photo.title;
  NSString *caption = photo.caption;
  
  if ( [title isEqualToString:@""] ) {
    if ( [caption isEqualToString:@""] ) {
      title = @"Unknown";
    } else {
      title   = photo.caption;
      caption = nil;
    }
  }
  self.title.text   = title;
  self.caption.text = caption;
}

- (void)downloadThumbnailImage:(FlickrPhotoObject *)photo;
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSURL *imgURL = [FlickrFetcher URLforPhoto:photo.dictionaryRepresentation format:FlickrPhotoFormatSquare];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:imgURL];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
      // causes the BOMStorage warning???
      UIImage *image = [UIImage imageWithData:data];
      
      // call main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        
        self.thumbnailImageView.image = image;
      });
    }];
    
    [task resume];
  });
}

@end
