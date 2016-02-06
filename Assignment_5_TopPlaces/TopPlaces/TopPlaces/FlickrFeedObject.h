//
//  FlickrFeedObject.h
//  TopPlaces
//
//  Created by Hannah Troisi on 2/5/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrFeedObject : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url resultsKeyPathString:(NSString *)keyPath NS_DESIGNATED_INITIALIZER;

- (void)updateFeed;

@end
