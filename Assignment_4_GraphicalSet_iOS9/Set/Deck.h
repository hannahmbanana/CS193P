//
//  Deck.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (Card *)drawRandomCard;
- (void)addCard:(Card *)card;
- (void)addCard:(Card *)card atTop:(BOOL)atTop;

@end
