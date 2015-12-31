//
//  Deck.m
//  Matchismo
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

@synthesize cards = _cards;

#pragma mark - Properties

// override cards getter to initialize cards array
- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}


#pragma mark - Instance Methods

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
  [self addCard:card atTop:NO];  // default to add at bottom
}

- (Card *)drawRandomCard
{
  Card *randomCard = nil;
  
  if ([self.cards count]) {
    unsigned idx = arc4random() % [self.cards count];
    randomCard = self.cards[idx];
    [self.cards removeObjectAtIndex:idx];
    
//    NSLog(@"Cards remaining in deck = %lu (flips = %lu)", (unsigned long)[self.cards count], 52 - (unsigned long)[self.cards count]);
  }
  
  return randomCard;
}

@end
