//
//  CardMatchingGame.m
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, assign, readwrite)  NSInteger       score;
@property (nonatomic, strong)             NSMutableArray  *cards;
@property (nonatomic, strong, readwrite)  NSMutableArray  *lastMatched;

@end

@implementation CardMatchingGame

@synthesize score = _score;
@synthesize lastScore = _lastScore;
@synthesize lastMatched = _lastMatched;
@synthesize cards = _cards;


#pragma mark - Getter / Setter Overrides

// lazy instantiation of _cards
- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}


#pragma mark - Initializers

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

static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;
static const int MATCH_BONUS = 4;

- (void)choseCardAtIndex:(NSUInteger)index
{
  // get card at index
  Card *card = [self.cards objectAtIndex:index];
  
  // 2 card matching game
  if (self.gameCardModeMaxCards == 2) {
    
    // reset lastMatched & lastScore properties?
    if ( ([self.lastMatched count] > 1) && (self.lastScore > 0) ) {
      // successful match
      [self.lastMatched removeAllObjects];
    } else if ( ([self.lastMatched count] > 1) && (self.lastScore < 0) ){
      // unsuccessful match
      [self.lastMatched removeObjectAtIndex:0];
    }
    
    self.lastScore = 0;
    
    // only allow unmatched cards to be chosen
    if (!card.isMatched) {
      
      // if it's already chosen, unchoose it
      if (card.isChosen) {
        card.chosen = NO;
        [self.lastMatched removeObject:card];
        
      } else {
        
        // add card to the lastMatched array
        [self.lastMatched addObject:card];
        
        // iterate through all the cards to see if any are chosen
        for (Card *otherCard in self.cards) {
          
          if (otherCard.isChosen && !otherCard.isMatched) {
            
            int matchScore = [card match:@[otherCard]];
            
            if (matchScore) {
              self.lastScore = matchScore * MATCH_BONUS;
              self.score += self.lastScore;
              otherCard.matched = YES;
              card.matched = YES;
            } else {
              self.lastScore -= MISMATCH_PENALTY;
              self.score += self.lastScore;
              otherCard.chosen = NO;
            }
          }
        }
        card.chosen = YES;
        self.score -= COST_TO_CHOOSE;
      }
    }
    
  // 3 card matching game
  } else {
    
    // reset lastMatched & lastScore properties?
    if ( ([self.lastMatched count] > 1) && (self.lastScore > 0) ) {
      // successful match
      [self.lastMatched removeAllObjects];
    } else if ( ([self.lastMatched count] > 1) && (self.lastScore < 0) ){
      // unsuccessful match
      [self.lastMatched removeObjectAtIndex:0];
      [self.lastMatched removeObjectAtIndex:1];
    }
    
    self.lastScore = 0;
    
    // only allow unmatched cards to be chosen
    if (!card.isMatched) {
      
      // if the card is already chosen, unchose it
      if (card.isChosen) {
        card.chosen = NO;
        [self.lastMatched removeObject:card];
        
      } else {
        
        // add card to the lastMatched array
        [self.lastMatched addObject:card];
        
        // check that 2 other cards are chosen
        int numChosenCards = 0;
        NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
        
        for (Card *otherCard in self.cards) {
          if (otherCard.isChosen && !otherCard.isMatched) {
            numChosenCards++;
            [chosenCards addObject:otherCard];
          }
        }
        
//        NSLog(@"# CARDS = %d", numChosenCards);
//        NSLog(@"chosenCards = %@", [chosenCards description]);
        
        // if 2 cards are chosen
        if (numChosenCards == 2) {
          
          // match cards against eachother
          int matchScore = [card match:[chosenCards copy]];
          
//          NSLog(@"chosenCards = %@", [chosenCards description]);
          
          NSArray *cardSet = [chosenCards arrayByAddingObject:card];
          
          // if match
          if (matchScore) {
            // adjust game score
            self.lastScore = matchScore * MATCH_BONUS;
            self.score += self.lastScore;
            // mark cards as matched
            for (Card *card in cardSet) {
              card.matched = YES;
            }
          } else {
            // adjust game score
            self.lastScore -= MISMATCH_PENALTY;
            self.score += self.lastScore;
            // mark cards as unchosen
            for (Card *card in cardSet) {
              card.chosen = NO;
            }
          }
        }
        
        // mark chosen card as chosen
        card.chosen = YES;
      }
    }
  }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
  return [self.cards objectAtIndex:index];
}

@end
