//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

#pragma mark - Lifecycle

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    
    for (NSString *suit in [PlayingCard validSuits]) {
      for (NSUInteger rank=1; rank <= [PlayingCard maxRank]; rank++) {
        PlayingCard *card = [[PlayingCard alloc] init];
        card.rank = rank;
        card.suit = suit;
        
        [self addCard:card]; // don't forget that we are a Deck!
      }
    }
  }
  
  return self;
}

@end
