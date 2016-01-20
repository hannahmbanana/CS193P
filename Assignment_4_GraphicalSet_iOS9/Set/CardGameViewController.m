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
#import "PlayingCardView.h"



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

+ (Class)cardViewClass
{
  return [PlayingCardView class];
}

+ (NSUInteger)numCardsInMatch
{
  return 2;
}

+ (NSUInteger)numCardsInGame
{
  return 30;
}

#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    // set navigation title
    self.navigationItem.title = @"Card Matching";
  }
  return self;
}

@end
