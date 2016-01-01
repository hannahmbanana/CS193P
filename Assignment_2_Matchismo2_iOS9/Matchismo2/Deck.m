//
//  Deck.m
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "Deck.h"

@interface Deck ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation Deck

@synthesize cards = _cards;

#pragma mark - Getter / Setter Overrides

// lazy instatiation
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
