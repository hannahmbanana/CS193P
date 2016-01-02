//
//  MatchingGame.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/20/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "MatchingGame.h"

@interface MatchingGame()
// FIXME: MatchingGame+subclasses.h (to delete duplication of this code)
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (nonatomic, strong, readwrite) NSMutableArray *lastMatched;
@property (nonatomic, strong, readwrite) NSMutableArray *cards;
@end

@implementation MatchingGame

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

// subclasses MUST override this
- (void)choseCardAtIndex:(NSUInteger)index
{
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return [self.cards objectAtIndex:index];
}

@end
