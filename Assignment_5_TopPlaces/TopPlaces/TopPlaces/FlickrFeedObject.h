//
//  FlickrFeedObject.h
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPhotoObject.h"

@interface FlickrFeedObject : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url resultsKeyPathString:(NSString *)keyPath NS_DESIGNATED_INITIALIZER;

- (void)updateFeedWithCompletionBlock:(void (^)(void))blockName;
- (FlickrPhotoObject *)itemAtIndex:(NSUInteger)index;
- (NSUInteger)numItemsInFeed;

- (NSArray *)orderedCountriesArray;


@end
