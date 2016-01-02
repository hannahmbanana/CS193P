//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Hannah Troisi on 10/14/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"
@import UIKit;

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        
        for (NSString *shape in [SetCard validShapes]) {
            for (NSUInteger number=1; number <= [SetCard maxNumber]; number++) {
                for (NSString *shade in [SetCard validShades]) {
                    for (UIColor *color in [SetCard validColors]) {
                        
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.number = number;
                        card.shade = shade;
                        card.color = color;
                    
                        [self addCard:card]; // don't forget that we are a Deck!
                    }
                }
            }
        }
    }
    
    return self;
}

@end
