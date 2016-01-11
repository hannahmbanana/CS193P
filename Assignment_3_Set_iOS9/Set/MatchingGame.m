//
//  MatchingGame.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "MatchingGame.h"


@implementation MatchingGame

#pragma mark - Properties

// lazy instantiation of _cards
- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}


#pragma mark - Lifecycle

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
  self = [super init];
  
  if (self) {
    
    // populate cards array with cards from deck
    for (int i=0; i < count; i++) {
      
      Card *card = [deck drawRandomCard];
      
      if (card) {
        [self.cards addObject:card];
      } else {
        return nil;
      }
    }
  }
  
  _lastMatched = [[NSMutableArray alloc] init];
  return self;
}

#pragma mark - Instance Methods

// subclasses MUST override this
- (void)choseCardAtIndex:(NSUInteger)index
{
}

- (Card *)cardAtIndex:(NSUInteger)index
{
  return [self.cards objectAtIndex:index];
}

@end
