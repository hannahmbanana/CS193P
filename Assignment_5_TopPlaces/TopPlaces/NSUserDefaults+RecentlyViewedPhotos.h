//
//  NSUserDefaults+RecentlyViewedPhotos.h
//  TopPlaces
//
//  Created by Hannah Troisi on 2/7/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPhotoObject.h"

@interface NSUserDefaults (RecentlyViewedPhotos)

+ (void)resetUsersRecentlyViewedPhotos;
+ (NSArray *)getUsersRecentlyViewedPhotos;
+ (void)addUsersRecentlyViewedPhoto:(FlickrPhotoObject *)photo;

@end
