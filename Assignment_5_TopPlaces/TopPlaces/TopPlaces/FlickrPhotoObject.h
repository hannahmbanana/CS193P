//
//  FlickrPhotoObject.h
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotoObject : NSObject

@property (nonatomic, strong, readwrite) NSDictionary *dictionaryRepresentation;
@property (nonatomic, strong, readwrite) NSString     *title;
@property (nonatomic, strong, readwrite) NSString     *caption;
@property (nonatomic, strong, readwrite) NSString     *country;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)photoDictionary NS_DESIGNATED_INITIALIZER;


@end
