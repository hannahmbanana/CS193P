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
  
  // update game commentary label
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
  
  for (Card *card in self.game.lastMatched) {
    [string appendAttributedString:[self attributedTitleForCard:card override:YES]];
  }

  // 2 cards case
  if ([self.game.lastMatched count] > 1) {

    NSString *commentary;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};

    if (self.game.lastScore < 0) {
      commentary = [NSString stringWithFormat:@" don't match %ld point penalty.\n\n", (long)self.game.lastScore];
    } else {
      commentary = [NSString stringWithFormat:@" matched for %ld points!\n\n", (long)self.game.lastScore];
    }
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:commentary attributes:attributes]];
    
    NSMutableAttributedString *test = [string mutableCopy];
    [test appendAttributedString:self.gameCommentaryHistory];
    self.gameCommentaryHistory = test;
    
  } else if ([self.game.lastMatched count]) {
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
  }

  self.gameCommentaryLabel.attributedText = string;
  [self.view setNeedsLayout];
//  NSLog(@"commentary = %@", self.gameCommentaryLabel);
}


#pragma mark - ButtonGridViewDelegate Methods

- (NSAttributedString *)attributedTitleForCard:(Card *)card override:(BOOL)override
{  
  NSAttributedString *title;
  
  if (override) {
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
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

- (BOOL)shadowForCardAtIndex:(NSUInteger)index;                 // SUBCLASS MUST IMPLEMENT
{
  return NO;
}

@end
