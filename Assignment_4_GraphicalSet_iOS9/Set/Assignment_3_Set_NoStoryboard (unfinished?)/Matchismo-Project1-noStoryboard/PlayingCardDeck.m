//
//  PlayingCardDeck.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        // create the playing cards & add to deck
        for (NSString *suit in [PlayingCard validSuits]) {
            for (int rank=1; rank <= [PlayingCard maxRank]; rank++) {
                
                PlayingCard *card = [[PlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
