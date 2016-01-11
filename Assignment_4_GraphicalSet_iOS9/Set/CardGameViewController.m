//
//  CardGameViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@implementation CardGameViewController


#pragma mark - Class Methods

+ (Class)gameClass
{
  return [CardMatchingGame class];
}

+ (Class)deckClass
{
  return [PlayingCardDeck class];
}

+ (NSUInteger)numCardsInMatch
{
  return 2;
}


#pragma mark - Lifecycle

- (instancetype)initWithColumnCount:(NSUInteger)numCols rowCount:(NSUInteger)numRows
{
  self = [super initWithColumnCount:numCols rowCount:numRows];
  if (self) {
    
    // set navigation title
    self.navigationItem.title = @"Card Matching";
  }
  return self;
}


#pragma mark - ButtonGridViewDelegate Methods

- (NSAttributedString *)attributedTitleForCard:(Card *)card overrideIsChosenCheck:(BOOL)override
{  
  NSAttributedString *title;
  
  if (override) {
    NSDictionary *attributes = [[super class] attributesDictionary];
    title = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
  } else {
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor blackColor]};
    if (card.isChosen) {
      title = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
    } else {
      title = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    }
  }
  return title;
}

- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)cardButtonIndex
{
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  return card.isChosen ? [UIImage imageNamed:@"cardfront"] : [UIImage imageNamed:@"cardback"];
}

- (BOOL)shadowForCardAtIndex:(NSUInteger)index; 
{
  return NO;
}

@end
