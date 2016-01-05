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

- (void)updateUI // fixme:
{
  [super updateUI];
  
  NSMutableAttributedString *label = [[NSMutableAttributedString alloc] init];
      
//    // update game commentary
//    if ([self.game.lastMatched containsObject:card]) {
//      
//      // create a UIImage of the card
//      NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//      textAttachment.image = [self imageFromString:attributedCardString];
//      NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//      
//      [label appendAttributedString:attrStringWithImage];
//    }
//  }
//  
//  
//  // update game commentary
//  // 3 cards case
//  if ([self.game.lastMatched count] > 2) {
//    
//    if (self.game.lastScore < 0) {
//      [label appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" are NOT a set.\n%ld point penalty.\n\n", (long)self.game.lastScore]]];
//    } else {
//      [label appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" are a set! %ld points!\n\n", (long)self.game.lastScore]]];
//    }
//  }
//  
//  [self.gameCommentaryLabel setAttributedText:label];
//  [self.gameCommentaryHistory appendAttributedString:label];
}


- (UIImage *)imageFromString:(NSAttributedString *)string
{  
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
