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
#import "SetCardView.h"
#import <QuartzCore/QuartzCore.h>
#import "CardCollectionViewCell.h"

@interface SetGameViewController ()
@property (nonatomic, strong, readwrite)   NSMutableArray *visibleCards;
@property (nonatomic, assign, readwrite)   NSUInteger highestIndex;
@end

@implementation SetGameViewController
{
  UIButton *_btn;
}

#pragma mark - Class Methods

+ (Class)gameClass
{
  return [SetMatchingGame class];
}

+ (Class)deckClass
{
  return [SetCardDeck class];
}

+ (Class)cardViewClass
{
  return [SetCardView class];
}

+ (NSUInteger)numCardsInMatch
{
  return 3;
}


#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    // set navigation title
    self.navigationItem.title = @"Classic Set";
    
    _visibleCards = [[self.game.cards subarrayWithRange:NSMakeRange(0, 20)] mutableCopy];  // FIXME: number
    self.highestIndex = 20 - 1;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // create deal3Button
  _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_btn setTitle:@"Deal 3" forState:UIControlStateNormal];
  [_btn addTarget:self action:@selector(dealThreeCards) forControlEvents:UIControlEventTouchUpInside];
  [_btn setTintColor:[UIColor whiteColor]];
  
  [self.view addSubview:_btn];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  // set frame for dealButton
  [_btn sizeToFit];
  CGRect dealButtonFrame = self.dealButton.frame;
  dealButtonFrame.size = _btn.frame.size;
  dealButtonFrame.origin = CGPointMake(dealButtonFrame.origin.x - _btn.frame.size.width - 20,
                                       dealButtonFrame.origin.y);
  _btn.frame = dealButtonFrame;
}


#pragma mark - Instance Methods

- (void)dealThreeCards
{
  NSUInteger newGameIdx;
  NSMutableArray *idxPathArray = [NSMutableArray array];

  // add up to 3 cards to self.visibleCards
  for (int i = 0; i < 3; i++) {
    
    newGameIdx = self.highestIndex + 1;
    
    Card *newCard = [self.game.cards objectAtIndex:newGameIdx];
    
    if (newCard) {
      
      // if card exists in game
      [self.visibleCards addObject:newCard];
      
      [idxPathArray addObject:[NSIndexPath indexPathForItem:[self.visibleCards count]-1 inSection:0]];
      
      self.highestIndex += 1;
      
    } else {
      
      // no cards left in game, hide "deal 3" button
      _btn.hidden = YES;
    }
  }
  
//   reload UICollectionView data
  if (idxPathArray) {
    [self.collectionView insertItemsAtIndexPaths:idxPathArray];
  }
}


- (void)touchCardButtonAtIndex:(NSUInteger)cardButtonIndex
{
  Card *cardVisible = [self.visibleCards objectAtIndex:cardButtonIndex];
  NSUInteger cardIndex = [self.game.cards indexOfObjectIdenticalTo:cardVisible];
  [super touchCardButtonAtIndex:cardIndex];
  
  // remove matched cards
  NSMutableArray *indexPathsToRemove = [[NSMutableArray alloc] init];
  for (Card *card in _visibleCards) {
    if (card.isMatched) {
      NSInteger itemIndex = [_visibleCards indexOfObjectIdenticalTo:card];
      [indexPathsToRemove addObject:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
    }
  }
  
  // reverseObjectEnumerator allows us to delete indices backwards so that you don't mess up the next index to delete
  for (NSIndexPath *indexPath in [indexPathsToRemove reverseObjectEnumerator]) {
    [_visibleCards removeObjectAtIndex:indexPath.item];
  }
  
  [self.collectionView deleteItemsAtIndexPaths:indexPathsToRemove];
}

- (void)touchDealButton
{
  [super touchDealButton];
  
  _visibleCards = [[self.game.cards subarrayWithRange:NSMakeRange(0, 20)] mutableCopy];  // FIXME: number, duplication of code
  self.highestIndex = 20 - 1;
  
  _btn.hidden = NO;
}


#pragma mark - UICollectionViewDataSource Protocol Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  // reloadItemsAtIndexPath FIXME: // containsObjectIdenticalTo or use isSelected
  return [self.visibleCards count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  Card *cardVisible = [self.visibleCards objectAtIndex:indexPath.item];
  NSUInteger cardIndex = [self.game.cards indexOfObjectIdenticalTo:cardVisible];
  Card *card = [self.game cardAtIndex:cardIndex];
  
  CardCollectionViewCell *newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];
  newCell.card = card;
  
  return newCell;
}


@end
