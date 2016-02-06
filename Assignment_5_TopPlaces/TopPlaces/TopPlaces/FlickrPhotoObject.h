//
//  FlickrPhotoObject.h
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotoObject : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)photoDictionary NS_DESIGNATED_INITIALIZER;


@end
