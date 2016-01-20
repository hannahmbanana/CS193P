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

static const int NUM_CARDS_AT_START_OF_GAME = 12;

@interface SetGameViewController ()
@property (nonatomic, strong, readwrite)   NSMutableArray *visibleCards;
@property (nonatomic, assign, readwrite)   NSUInteger     highestIndex;
@end

@implementation SetGameViewController
{
  UIButton *_btn;
  CGSize   _itemSize;
  UIButton *_matchesAvailable;
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

+ (NSUInteger)numCardsInGame
{
  return 81;
}


#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    // set navigation title
    self.navigationItem.title = @"Classic Set";
    
    [self resetVisibleCards];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // UIBarButtonItems
  UIBarButtonItem *deal = [[UIBarButtonItem alloc] initWithTitle:@"+3 Cards"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(dealThreeCards)];
  
  UIBarButtonItem *showMatch = [[UIBarButtonItem alloc] initWithTitle:@"Hint"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(showMatch)];
  
  // UIToolBar
  self.toolBar.items = [[self.toolBar items] arrayByAddingObjectsFromArray:@[showMatch, deal]];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  // recalculate cardSize for UICollectionView
  _itemSize = [self calculateItemSize];
  
  // invalidate layout to force new itemSize
  [self.collectionView.collectionViewLayout invalidateLayout];
  
  // check if any matches available
  [self setMatchButtonVisibility];
}


#pragma mark - Instance Methods

- (NSArray *)matchInVisibleCards
{
  return [(SetMatchingGame *)self.game matchInSet:self.visibleCards];
}

- (void)setMatchButtonVisibility
{
  NSArray *matchedCards = [self matchInVisibleCards];
  
  if ([matchedCards count] > 0) {
    [[self.toolBar.items objectAtIndex:2] setEnabled:YES];
  } else {
    [[self.toolBar.items objectAtIndex:2] setEnabled:NO];
  }
}

- (void)showMatch
{
  NSArray *matchedCards = [self matchInVisibleCards];
  
  for (Card *card in matchedCards) {
    NSUInteger cardVisibleIdx = [self.visibleCards indexOfObjectIdenticalTo:card];
    NSIndexPath *path = [NSIndexPath indexPathForItem:cardVisibleIdx inSection:0];
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:path];
    [cell fadeIn];
  }
}

- (void)dealThreeCards
{
  NSUInteger newGameIdx;
  NSMutableArray *idxPathArray = [NSMutableArray array];
  
  // add up to 3 cards to self.visibleCards
  for (int i = 0; i < 3; i++) {
    
    newGameIdx = self.highestIndex + 1;
    
    if (newGameIdx < [self.game.cards count]) {
      
      Card *newCard = [self.game.cards objectAtIndex:newGameIdx];
      
      // if card exists in game
      [self.visibleCards addObject:newCard];
      
      [idxPathArray addObject:[NSIndexPath indexPathForItem:[self.visibleCards count]-1 inSection:0]];
      
      self.highestIndex += 1;
      
    } else {
      
      // no cards left in game, hide "deal 3" button
      [[self.toolBar.items objectAtIndex:3] setEnabled:NO];
    }
  }
  
  // reload UICollectionView data
  if (idxPathArray) {
    
    // trigger resizing of cells
    _itemSize = [self calculateItemSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    // insert cells
    [self.collectionView insertItemsAtIndexPaths:idxPathArray];
  }
  
  [self setMatchButtonVisibility];
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
  
  // trigger resizing of cells
  _itemSize = [self calculateItemSize];
  [self.collectionView.collectionViewLayout invalidateLayout];
  
  [self setMatchButtonVisibility];
}

- (void)touchDealButton
{
  [super touchDealButton];
  
  [self resetVisibleCards];
  
  [[self.toolBar.items objectAtIndex:3] setEnabled:YES];
  
  _itemSize = [self calculateItemSize];
  [self.collectionView.collectionViewLayout invalidateLayout];
  
  [self setMatchButtonVisibility];
}

- (void)resetVisibleCards
{
  _visibleCards = [[self.game.cards subarrayWithRange:NSMakeRange(0, NUM_CARDS_AT_START_OF_GAME)] mutableCopy];
  self.highestIndex = NUM_CARDS_AT_START_OF_GAME - 1;
}


#pragma mark - Layout

- (CGSize)calculateItemSize
{
  CGSize bounds = self.collectionView.bounds.size;
  
  CGFloat numCards = [self.visibleCards count];
  CGFloat cardAspectRatio = 1.57;
  
  UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  UIEdgeInsets insets = flowLayout.sectionInset;
  CGFloat spacing = flowLayout.minimumInteritemSpacing;
  CGFloat lineSpacing = flowLayout.minimumLineSpacing;
  
  BOOL doneSizing = NO;
  CGFloat numColumns = 1;
  CGFloat numRows;
  CGFloat availableCardSpan, cardWidth, cardHeight, cardGridHeight;
  CGSize cardSize;
  
  // For loop adding columns until cards fit
  while (!doneSizing) {
    
    availableCardSpan = bounds.width - insets.left - insets.right;
    cardWidth         = floorf( (availableCardSpan - (numColumns - 1) * spacing) / numColumns );
    cardHeight        = floorf( cardWidth * cardAspectRatio );
    cardSize          = CGSizeMake( cardWidth, cardHeight );
    
    numRows           = ceilf( numCards / numColumns );
    
    cardGridHeight    = numRows * cardHeight +
                        (numRows - 1) * lineSpacing +
                        insets.top + insets.bottom;
    
//    NSLog(@"%@", NSStringFromCGSize(cardSize));
//    NSLog(@" numCards %2.0f / numColumns %2.0f = numRows %3.0f", numCards, numColumns, numRows);
//    NSLog(@"cardGridHeight %f < bounds.height %f\n\n", cardGridHeight, bounds.height);
    
    if (cardGridHeight < bounds.height) {
      doneSizing = YES;
    }
    
    numColumns++;
  }
  
  return cardSize;
}


#pragma mark - UICollectionViewDelegateFlowLayout Protocol Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return _itemSize;
}


#pragma mark - UICollectionViewDataSource Protocol Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
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
