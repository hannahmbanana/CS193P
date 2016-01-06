//
//  SetGameViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import <QuartzCore/QuartzCore.h>

@implementation SetGameViewController


#pragma mark - Class Methods

+ (Class)gameClass
{
  return [SetMatchingGame class];
}


#pragma mark - Instance Methods

- (Deck *)createDeck
{
  return [[SetCardDeck alloc] init];
}

- (void)updateUI
{
  [super updateUI];
  
  // update game commentary label
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
  
  for (Card *card in self.game.lastMatched) {
    
    // create a UIImage of the card
    NSAttributedString *attributedCardString = [self attributedTitleForCard:card override:YES];

    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [self imageFromString:attributedCardString];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [string appendAttributedString:attrStringWithImage];
  }
  
  // 3 card case
  if ([self.game.lastMatched count] > 2) {
    
    NSString *commentary;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    if (self.game.lastScore < 0) {
      commentary = [NSString stringWithFormat:@" are NOT a set (%ld point)\n\n", (long)self.game.lastScore];
    } else {
      commentary = [NSString stringWithFormat:@" are a set (+%ld points)!\n\n", (long)self.game.lastScore];
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

- (UIImage *)imageFromString:(NSAttributedString *)string
{
  // FIXME: add white card background
  CGSize stringSize = [string size];
  UIGraphicsBeginImageContextWithOptions(stringSize, NO, 0);
  [string drawInRect:CGRectMake(0, 0, stringSize.width, stringSize.height)];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}


#pragma mark - ButtonGridViewDelegate Methods

- (NSAttributedString *)attributedTitleForCard:(Card *)setCard override:(BOOL)override
{
  SetCard *card = (SetCard *)setCard;
  
  // set attributes for card's color
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:card.color forKey:NSForegroundColorAttributeName];

  // set attributes for card's fill
  if ([card.shade isEqualToString:@"solid"]) {
    [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];

  } else if ([card.shade isEqualToString:@"striped"]) {
    [attributes addEntriesFromDictionary:@{ NSStrokeWidthAttributeName      : @-5,
                                            NSStrokeColorAttributeName      : attributes[NSForegroundColorAttributeName],
                                            NSForegroundColorAttributeName  : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.3]}];

  } else if ([card.shade isEqualToString:@"open"]) {
    [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
  }

  // create the correct string for card's number, shape
  NSMutableString *numberShapeString = [[NSMutableString alloc] init];
  for (int i = 1; i <= card.number; i++) {
    [numberShapeString appendString:card.shape];
    if (i != card.number) {
      [numberShapeString appendString:@"\n"];
    }
  }

  // create the attributed string
  NSAttributedString *title = [[NSAttributedString alloc] initWithString:[numberShapeString copy] attributes:attributes];

  return title;
}

- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)cardButtonIndex
{
  return [UIImage imageNamed:@"cardfront"];
}

- (BOOL)shadowForCardAtIndex:(NSUInteger)cardButtonIndex;
{
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  
  if (card.isChosen && !card.isMatched) {
    return YES;
  } else {
    return NO;
  }
}

@end
