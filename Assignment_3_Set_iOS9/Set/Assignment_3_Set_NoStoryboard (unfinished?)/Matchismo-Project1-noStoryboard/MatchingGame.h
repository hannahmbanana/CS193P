//
//  MatchingGame.h
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/20/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

// abstract class
@interface MatchingGame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger lastScore;
@property (nonatomic, strong, readonly) NSMutableArray *lastMatched;
@property (nonatomic, strong, readonly) NSMutableArray *cards;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck NS_DESIGNATED_INITIALIZER;

// subclasses MUST override this
- (void)choseCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@end
