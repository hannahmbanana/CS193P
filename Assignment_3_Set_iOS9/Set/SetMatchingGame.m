//
//  SetMatchingGame.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "SetMatchingGame.h"
#import "SetCard.h"

@interface MatchingGame()
@property (nonatomic, assign, readwrite) NSInteger      score;
@property (nonatomic, assign, readwrite) NSInteger      lastScore;
@property (nonatomic, strong, readwrite) NSMutableArray *lastMatched;
@property (nonatomic, strong, readwrite) NSMutableArray *cards;
@end

@implementation SetMatchingGame

static const int MISMATCH_PENALTY = 1;
static const int MATCH_BONUS = 2;

- (void)choseCardAtIndex:(NSUInteger)index
{
  Card *card = [self.cards objectAtIndex:index];
  
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
      
//      NSLog(@"# CARDS = %d", numChosenCards);
//      NSLog(@"chosenCards = %@", [chosenCards description]);
      
      // if 2 cards are chosen
      if (numChosenCards == 2) {
        
        // match cards against eachother
        int matchScore = [card match:[chosenCards copy]];
        
//        NSLog(@"chosenCards = %@", [chosenCards description]);
        
        NSArray *cardSet = [chosenCards arrayByAddingObject:card];
        
        // if match
        if (matchScore) {
          // adjust game score
          self.lastScore = matchScore * MATCH_BONUS;
          self.score += self.lastScore;
          // mark cards as matched
          for (SetCard *card in cardSet) {
            card.matched = YES;
          }
        } else {
          // adjust game score
          self.lastScore -= MISMATCH_PENALTY;
          self.score += self.lastScore;
          // mark cards as unchosen
          for (SetCard *card in cardSet) {
            card.chosen = NO;
          }
        }
      }
      
      // mark chosen card as chosen
      card.chosen = YES;
    }
  }
}

@end
