//
//  Deck.h
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (Card *)drawRandomCard;

- (void)addCard:(Card *)card;

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

@end
