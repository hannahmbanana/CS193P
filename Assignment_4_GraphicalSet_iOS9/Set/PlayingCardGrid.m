//
//  PlayingCardGridView.m
//  Set
//
//  Created by Hannah Troisi on 1/11/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "PlayingCardGrid.h"
#import "PlayingCardView.h"
#import "CardMatchingGame.h"

@implementation PlayingCardGrid


#pragma mark - Class Methods

+ (Class)cardViewClass
{
  return [PlayingCardView class];
}


#pragma mark - Lifecycle

- (instancetype)initWithColumns:(NSUInteger)columnCount
                           rows:(NSUInteger)rowCount
                       delegate:(id<ButtonGridViewDelegate>)delegate
                          game:(CardMatchingGame *)game;
{
  self = [super initWithColumns:columnCount rows:rowCount delegate:delegate game:game];
  
  if (self) {
        
    // add columnCount * rowCount number of card Views to the cardButtonArray
    for (Card *card in game.cards) {
      
      // initialize & configure the card button
      PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:CGRectZero card:card];
      
      // add tap gesture recognizer
      UITapGestureRecognizer *tGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouched:)];
      tGR.numberOfTapsRequired = 1;
      [cardView addGestureRecognizer:tGR];
      
      // add the card to the cardArray & to the UIView
      [self.cardArray addObject:cardView];  // FIXME: move all of this to layoutsubviews to avoid having to keep the cards in an array?
      [self addSubview:cardView];
    }
  }
  return self;
}

// FIXME: give the CardView.h a model - initWithCard, update (check if properties are the same and change if not) OR NSNotificationStation (have the card model would notify, card view would listen)

# pragma mark - Helper Methods



@end
