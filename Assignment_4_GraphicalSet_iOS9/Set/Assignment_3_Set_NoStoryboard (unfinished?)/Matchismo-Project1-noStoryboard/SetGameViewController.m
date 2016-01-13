//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Hannah Troisi on 10/14/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
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

#pragma mark - Helper Methods

- (void) updateUI
{
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc] init];
    
    // for each card, update UI
    for (UIButton *cardButton in self.buttonGridView.cardButtonArray) {
        
        // get the index of the cardButton to find the correct card in the game
        NSUInteger cardButtonIndex = [self.buttonGridView.cardButtonArray
                                      indexOfObject:cardButton];
        
        SetCard *card = [self.game cardAtIndex:cardButtonIndex];
        
        // update button image
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                              forState:UIControlStateNormal];
        
        // make a dictionary of the card's color, shade attributes
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:card.color forKey:NSForegroundColorAttributeName];
        
        if ([card.shade isEqualToString:@"solid"]) {
            [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
            
        } else if ([card.shade isEqualToString:@"striped"]) {
            [attributes addEntriesFromDictionary:@{
                                                   NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.3]
                                                   }];
            
        } else if ([card.shade isEqualToString:@"open"]) {
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
            
        }
        
        // create the correct string (number, shape)
        NSMutableString *numberShapeString = [[NSMutableString alloc] init];
        for (int i = 1; i <= card.number; i++) {
            [numberShapeString appendString:card.shape];
            if (i != card.number) {
                [numberShapeString appendString:@"\n"];
            }
        }
        
        // create the attributed string
        NSAttributedString *attributedCardString =
        [[NSAttributedString alloc] initWithString:[numberShapeString copy]
                                        attributes:attributes];
        
        // set to be the card's title
        if (!card.isMatched) {
            [cardButton setAttributedTitle:attributedCardString
                                  forState:UIControlStateNormal];
            cardButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cardButton.titleLabel.numberOfLines = 3;
            cardButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            cardButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
        
        // disable card if matched
        if (card.isMatched) {
            cardButton.enabled = NO;
            [self performSelector:@selector(clearTitle:) withObject:cardButton afterDelay:0.7];
            [cardButton setAlpha:0.4];
        } else {
            cardButton.enabled = YES;
            [cardButton setAlpha:1.0];
        }
        
        // highlight card if selected
        if (card.isChosen && !card.isMatched) {
            cardButton.layer.shadowColor = [UIColor blackColor].CGColor;
            cardButton.layer.shadowOffset = CGSizeMake(4.0,4.0);
            cardButton.layer.shadowOpacity = 1.0;
            cardButton.layer.shadowRadius = 0.0;
        } else {
            cardButton.layer.shadowOffset = CGSizeZero;
        }
        
        // update game commentary
        if ([self.game.lastMatched containsObject:card]) {
            
            // create a UIImage of the card
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [self imageFromString:attributedCardString];
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];

            [label appendAttributedString:attrStringWithImage];
        }
    }
    
    // update game score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    
    // update game commentary
    // 3 cards case
    if ([self.game.lastMatched count] > 2) {
        
        if (self.game.lastScore < 0) {
            [label appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" are NOT a set.\n%ld point penalty.\n\n", (long)self.game.lastScore]]];
        } else {
            [label appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" are a set! %ld points!\n\n", (long)self.game.lastScore]]];
        }
    }
    
    [self.gameCommentaryLabel setAttributedText:label];
    [self.gameCommentaryHistory appendAttributedString:label];
}


- (UIImage *)imageFromString:(NSAttributedString *)string
{
    // FIXME: add white card background to image
    
    CGSize stringSize = [string size];
    UIGraphicsBeginImageContextWithOptions(stringSize, NO, 0);
    [string drawInRect:CGRectMake(0, 0, stringSize.width, stringSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
                         
- (Deck *)createDeck
 {
     return [[SetCardDeck alloc] init];
 }

- (void)clearTitle:(UIButton *)cardButton
{
    [cardButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@""] forState:UIControlStateNormal];
}

// FIXME: prompt user if more sets available

@end
