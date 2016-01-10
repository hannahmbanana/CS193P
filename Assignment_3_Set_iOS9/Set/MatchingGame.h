//
//  MatchingGame.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

// abstract class
@interface MatchingGame : NSObject

@property (nonatomic, assign, readonly) NSInteger       score;
@property (nonatomic, assign, readonly) NSInteger       lastScore;
@property (nonatomic, strong, readonly) NSMutableArray  *lastMatched;
@property (nonatomic, strong, readonly) NSMutableArray  *cards;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck NS_DESIGNATED_INITIALIZER;

- (Card *)cardAtIndex:(NSUInteger)index;

// subclasses MUST override this
- (void)choseCardAtIndex:(NSUInteger)index;

@end
