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


#pragma mark - Instance Methods

- (Deck *)createDeck
{
  return [[PlayingCardDeck alloc] init];
}

- (void)updateUI
{
  [super updateUI];
  
  // update game commentary 
  NSMutableString *label = [NSMutableString string];
  for (Card *card in self.game.lastMatched) {
    [label appendString:card.contents];
  }
  
  // 2 cards case
  if ([self.game.lastMatched count] > 1) {
    
    if (self.game.lastScore < 0) {
      [label appendFormat:@" don't match.\n%ld point penalty.\n\n", (long)self.game.lastScore];
    } else {
      [label appendFormat:@" matched for %ld points!\n\n", (long)self.game.lastScore];
    }
  } else if ([self.game.lastMatched count]) {
    [label appendString:@"\n\n"];
  }
  
  self.gameCommentaryLabel.text = label;
  
  [self.gameCommentaryHistory appendAttributedString:[[NSAttributedString alloc] initWithString:label]];
  NSLog(@"label = %@", label);  // FIXME
}


#pragma mark - ButtonGridViewDelegate Methods

- (NSAttributedString *)attributedTitleForCardAtIndex:(NSUInteger)cardButtonIndex
{
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  
  NSAttributedString *title;
  NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor blackColor]};
  
  if (card.isChosen) {
    title = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
  } else {
    title = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
  }
  return title;
}

- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)cardButtonIndex
{
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  return card.isChosen ? [UIImage imageNamed:@"cardfront"] : [UIImage imageNamed:@"cardback"];
}

- (BOOL)shadowForCardAtIndex:(NSUInteger)index;                 // SUBCLASS MUST IMPLEMENT
{
  return NO;
}

@end
