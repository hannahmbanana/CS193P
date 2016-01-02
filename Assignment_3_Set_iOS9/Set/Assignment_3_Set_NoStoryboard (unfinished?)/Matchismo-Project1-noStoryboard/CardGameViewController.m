//
//  CardGameViewController.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
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

#pragma mark - Helper Methods

- (void)updateUI
{
    // for each card
    for (UIButton *cardButton in self.buttonGridView.cardButtonArray) {
        
        // get card corresponding to UIButton
        NSUInteger cardButtonIndex = [self.buttonGridView.cardButtonArray
                                      indexOfObject:cardButton];
        
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        // update button image
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        
        // update button title
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        
        // disable card if matched
        if (card.isMatched) {
            cardButton.enabled = NO;
            [cardButton setAlpha:0.4];
        } else {
            cardButton.enabled = YES;
            [cardButton setAlpha:1.0];
        }
        
    }
    
    // update game score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",
                        self.game.score];
    
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
    }
    
    self.gameCommentaryLabel.text = label;
    
    [self.gameCommentaryHistory appendAttributedString:[[NSAttributedString alloc] initWithString:label]];
    

    
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return card.isChosen ?
    [UIImage imageNamed:@"cardfront"] : [UIImage imageNamed:@"cardback"];
}

@end
