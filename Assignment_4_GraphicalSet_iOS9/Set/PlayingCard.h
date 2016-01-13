//
//  PlayingCard.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong, readwrite) NSString    *suit;
@property (nonatomic, assign, readwrite) NSUInteger  rank;

+ (NSUInteger)maxRank;
+ (NSArray *)validSuits;

@end
