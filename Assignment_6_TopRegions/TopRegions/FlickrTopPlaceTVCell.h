//
//  FlickrTopPlaceTVCell.h
//  TopPlaces
//
//  Created by Hannah Troisi on 2/8/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhotoObject.h"

@interface FlickrTopPlaceTVCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithPhoto:(FlickrPhotoObject *)photo;

- (void)updateCellWithPhoto:(FlickrPhotoObject *)photo;

@end
