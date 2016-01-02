//
//  Card.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong, readwrite)                    NSString  *contents;
@property (nonatomic, assign, readwrite, getter=isChosen)   BOOL      chosen;
@property (nonatomic, assign, readwrite, getter=isMatched)  BOOL      matched;

- (int)match:(NSArray *)otherCards;

@end