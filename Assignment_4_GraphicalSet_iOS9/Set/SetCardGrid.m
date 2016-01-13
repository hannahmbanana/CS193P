//
//  SetCardGrid.m
//  Set
//
//  Created by Hannah Troisi on 1/12/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "SetCardGrid.h"
#import "SetCardView.h"
#import "SetMatchingGame.h"

@implementation SetCardGrid

#pragma mark - Class Methods

+ (Class)cardViewClass
{
  return [SetCardView class];
}


#pragma mark - Lifecycle

- (instancetype)initWithColumns:(NSUInteger)columnCount
                           rows:(NSUInteger)rowCount
                       delegate:(id<ButtonGridViewDelegate>)delegate
                           game:(SetMatchingGame *)game;
{
  self = [super initWithColumns:columnCount rows:rowCount delegate:delegate game:game];
  
  if (self) {
    
    // add columnCount * rowCount number of card Views to the cardButtonArray
    for (Card *card in game.cards) {
      
      // initialize & configure the card button
      SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectZero card:card];
      
      // add tap gesture recognizer
      UITapGestureRecognizer *tGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouched:)];
      tGR.numberOfTapsRequired = 1;
      [cardView addGestureRecognizer:tGR];
      
      // add the card to the cardArray & to the UIView
      [self.cardArray addObject:cardView];
      [self addSubview:cardView];
    }
  }
  return self;
}

@end
