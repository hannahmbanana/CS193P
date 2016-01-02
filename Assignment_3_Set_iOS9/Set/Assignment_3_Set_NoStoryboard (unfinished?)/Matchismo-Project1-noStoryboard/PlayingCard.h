//
//  PlayingCard.h
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;


+ (NSUInteger)maxRank;

+ (NSArray *)validSuits;

// reimplements superclass method
- (int)match:(NSArray *)otherCards;

@end
