//
//  Deck.h
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (Card *)drawRandomCard;

- (void)addCard:(Card *)card;

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

@end
