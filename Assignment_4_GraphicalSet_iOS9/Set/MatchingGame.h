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

@property (nonatomic, assign, readwrite) NSInteger       score;
@property (nonatomic, assign, readwrite) NSInteger       lastScore;
@property (nonatomic, strong, readwrite) NSMutableArray  *lastMatched;
@property (nonatomic, strong, readwrite) NSMutableArray  *cards;
@property (nonatomic, strong, readwrite) NSDate          *startTimestamp;
@property (nonatomic, strong, readwrite) NSString        *gameName;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck NS_DESIGNATED_INITIALIZER;

- (Card *)cardAtIndex:(NSUInteger)index;

// subclasses MUST override this
- (void)choseCardAtIndex:(NSUInteger)index;

@end
