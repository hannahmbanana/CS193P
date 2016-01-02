//
//  CardMatchingGame.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "CardMatchingGame.h"

@interface MatchingGame()
// FIXME: MatchingGame+subclasses.h (to delete duplication of this code)
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastScore;
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
}

@end
