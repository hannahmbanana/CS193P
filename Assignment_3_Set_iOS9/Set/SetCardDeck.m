//
//  SetCardDeck.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

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
