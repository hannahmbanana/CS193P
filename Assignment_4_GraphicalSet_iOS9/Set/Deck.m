//
//  Deck.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
@property (strong, nonatomic, readwrite) NSMutableArray *cards;
@end

@implementation Deck


#pragma mark - Properties

// lazy instatiation of _cards
- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

#pragma mark - Instance Methods

- (Card *)drawRandomCard
{
  Card *randomCard = [[Card alloc] init];
  
  unsigned index = arc4random() % [self.cards count];
  randomCard = [self.cards objectAtIndex:index];
  [self.cards removeObjectAtIndex:index];
  
  return randomCard;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
  if (atTop) {
    [self.cards insertObject:card atIndex:0];
  } else {
    [self.cards addObject:card];
  }
}

- (void)addCard:(Card *)card
{
  [self addCard:card atTop:NO];
}

@end
