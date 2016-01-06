//
//  CardMatchingGame.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "CardMatchingGame.h"

@interface MatchingGame()

@property (nonatomic, assign, readwrite) NSInteger      score;
@property (nonatomic, assign, readwrite) NSInteger      lastScore;
@property (nonatomic, strong, readwrite) NSMutableArray *lastMatched;
@property (nonatomic, strong, readwrite) NSMutableArray *cards;
@end

@implementation CardMatchingGame

#pragma mark - Instance Methods

static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;
static const int MATCH_BONUS = 4;

- (void)choseCardAtIndex:(NSUInteger)index
{
  // get card at index
  Card *card = [self.cards objectAtIndex:index];

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
    if (card.isChosen) {
      // if it's already chosen, unchoose it

      card.chosen = NO;
      [self.lastMatched removeObject:card];
    } else {
      // else choose card

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
        
      // set card to chosen (might also be matched)
      card.chosen = YES;
      
      // deduct cost to choose from score
      self.score -= COST_TO_CHOOSE;
    }
  }
  
//  NSLog(@"self.lastMatched = %@", self.lastMatched);
}


@end
