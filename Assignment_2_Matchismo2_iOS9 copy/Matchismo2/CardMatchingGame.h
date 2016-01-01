//
//  CardMatchingGame.h
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, assign, readonly) NSInteger       score;
@property (nonatomic, assign)           NSInteger       lastScore;
@property (nonatomic, strong, readonly) NSMutableArray  *lastMatched;
@property (nonatomic, assign)           NSInteger       gameCardModeMaxCards;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck NS_DESIGNATED_INITIALIZER;

- (void)choseCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@end
