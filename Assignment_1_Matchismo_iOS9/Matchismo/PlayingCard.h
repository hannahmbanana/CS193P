//
//  PlayingCard.h
//  Matchismo
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString    *suit;
@property (nonatomic)         NSUInteger  rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
