//
//  GameViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "GameViewController.h"
#import "CardPileCollectionViewLayout.h"
#import "CardCollectionViewCell.h"
#import "Deck.h"

const static int TAB_BAR_HEIGHT = 40;
static const int MAX_NUM_SAVED_SCORES = 10;

@interface GameViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation GameViewController
{
  UICollectionViewFlowLayout        *_flowLayout;
  CardPileCollectionViewLayout      *_customLayout;
  UICollectionViewTransitionLayout  *_transitionLayout;
  UIPinchGestureRecognizer          *_pinchGR;
  UIPanGestureRecognizer            *_panGR;
  UITapGestureRecognizer            *_tapGR;
}


#pragma mark - Class Methods

// subclass must implement
+ (Class)gameClass
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return Nil;
}

// subclass must implement
+ (Class)deckClass
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return Nil;
}

// subclass must implement
+ (Class)cardViewClass
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return Nil;
}

// subclass must implement
+ (NSUInteger)numCardsInMatch
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return 0;
}

// subclass must implement
+ (NSUInteger)numCardsInGame
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return 0;
}


#pragma mark - Properties

// lazy instantiation for _game so that we can set it to nil when dealing
- (MatchingGame *)game
{
  if (!_game) {
    Deck *deck = [[[[self class] deckClass] alloc] init];
    _game = [[[[self class] gameClass] alloc] initWithCardCount:[[self class] numCardsInGame] usingDeck:deck];  // FIXME: hardcoded card count
  }
  
  return _game;
}


#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super initWithNibName:nil bundle:nil];
  
  if (self) {

  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // UICollectionViewLayouts
  _flowLayout                         = [[UICollectionViewFlowLayout alloc] init];
  _flowLayout.itemSize                = CGSizeMake(60, 100);  // FIXME:
  _flowLayout.minimumInteritemSpacing = 5;
  _flowLayout.minimumLineSpacing      = 5;
  _flowLayout.sectionInset            = UIEdgeInsetsMake(10, 10, 10, 10);
  
  // custom CollectionViewLayout for gathering card stack & transition layout
  _customLayout     = [[CardPileCollectionViewLayout alloc] init];
  _transitionLayout = [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:_flowLayout nextLayout:_customLayout];
  
  // UICollectionView
  self.collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.collectionView.delegate        = self;
  self.collectionView.dataSource      = self;
  self.collectionView.scrollEnabled   = NO;
  
  // make sure viewController doesn't mess with collectionView layout
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  // custom CollectionViewCell
  [self.collectionView registerClass:[CardCollectionViewCell class] forCellWithReuseIdentifier:@"card"];
  
  // gesture recognizers allow user to gather the cards up into a pile, move around pile and restore cards
  _pinchGR        = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
  _panGR          = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
  _tapGR          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];

  _panGR.enabled  = NO;
  _tapGR.enabled  = NO;
  
  // add gesture recognizers to UICollectionView
  [self.collectionView addGestureRecognizer:_pinchGR];
  [self.collectionView addGestureRecognizer:_panGR];
  [self.collectionView addGestureRecognizer:_tapGR];
  
  // rightBarButtonItem
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New Game"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(touchDealButton)];
  
  // UIBarButtonItems
  UIBarButtonItem *score = [[UIBarButtonItem alloc] initWithTitle:@"Score: 0"
                                                            style:UIBarButtonItemStylePlain
                                                           target:nil
                                                           action:nil];
  score.enabled = NO;
  
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
  
  
  // UIToolBar
  self.toolBar = [[UIToolbar alloc] init];
  self.toolBar.items = @[score, flexibleSpace];
  
  // add views as subviews
  [self.view addSubview:self.collectionView];
  [self.view addSubview:self.toolBar];
  
  [self updateScore];
}


- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  CGSize boundsSize             = self.view.bounds.size;
  CGRect tabBarControllerFrame  = self.tabBarController.tabBar.frame;
  CGRect navControllerFrame     = self.navigationController.navigationBar.frame;
  
  // set frame for UIToolBar
  self.toolBar.frame = CGRectMake(0,
                              CGRectGetMinY(tabBarControllerFrame) - TAB_BAR_HEIGHT,
                              boundsSize.width,
                              TAB_BAR_HEIGHT);
  
  // set frame for UICollectionView
  self.collectionView.frame = CGRectMake(0,
                                         CGRectGetMaxY(navControllerFrame),
                                         boundsSize.width,
                                         CGRectGetMinY(self.toolBar.frame) - CGRectGetMaxY(navControllerFrame));
}


#pragma mark - User Actions

- (void)touchDealButton
{
  // save game score & other metadata to NSUserDefaults
  if (self.game.score && self.game.startTimestamp) {
    [self saveGameWithScore:self.game.score gameType:self.game.gameName start:self.game.startTimestamp];
  }
  
  // remove current game & gameCommentary History
  self.game = nil;
  
  // update score
  [self updateScore];
  
  // reload collectionView
  [self.collectionView reloadData];
}


#pragma mark - Instance Methods

- (void)updateScore
{
  // update game score
  UIBarButtonItem *score = [self.toolBar.items objectAtIndex:0];
  score.title = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)touchCardButtonAtIndex:(NSUInteger)cardButtonIndex
{
  // update game model
  [self.game choseCardAtIndex:cardButtonIndex];
  
  // update score
  [self updateScore];
}


#pragma mark - UICollectionViewDelegate Protocol Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  [self touchCardButtonAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
  [(CardCollectionViewCell *)cell fadeIn];
}


#pragma mark - UICollectionViewDataSource Protocol Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.game.cards count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  Card *card = [self.game cardAtIndex:indexPath.item];
  CardCollectionViewCell *newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];
  newCell.card = card;
  
  return newCell;
}


#pragma mark - Gesture Handling

- (void)handleTapGesture:(UIPanGestureRecognizer *)sender
{
  // return cards to normal layout in animated way
  [_collectionView setCollectionViewLayout:_flowLayout animated:YES];
  _collectionView.allowsSelection = YES;
  
  // recenter collection view
  self.collectionView.bounds = self.view.bounds;
  
  // disable pan and tap gestures, enable pinch gesture
  _panGR.enabled = NO;
  _tapGR.enabled = NO;
  _pinchGR.enabled = YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
  static CGPoint originalCenter;
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    
    originalCenter = sender.view.center;
    
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    
    CGPoint translation = [sender translationInView:sender.view.superview];
    sender.view.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y + translation.y);
  }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender
{
  if ([sender numberOfTouches] != 2)
    return;
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    
    CGPoint pinchPoint = [sender locationInView:sender.view];
    _customLayout.pinchPointCenter = CGPointMake( pinchPoint.x , pinchPoint.y ); 
    
    [_collectionView setCollectionViewLayout:_transitionLayout];
    
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    
    // Update the custom layout parameter and invalidate.
    _transitionLayout.transitionProgress = 1 - sender.scale;
    
    [_customLayout invalidateLayout];
    
  } else if (sender.state == UIGestureRecognizerStateEnded |
             sender.state == UIGestureRecognizerStateCancelled |
             sender.state == UIGestureRecognizerStateFailed) {
    
    _transitionLayout.transitionProgress = 1;
    [_customLayout invalidateLayout];
    
    _collectionView.allowsSelection = NO;
    _pinchGR.enabled = NO;
    _panGR.enabled = YES;
    _tapGR.enabled = YES;
    
  }
}


#pragma mark - NSUser Defaults


- (void)saveGameWithScore:(NSInteger)score gameType:(NSString *)game start:(NSDate *)startDate
{
  // create game dictionary with 4 metadata keys
  NSDictionary *gameData = @{@"gameType": game,
                             @"score": [NSNumber numberWithInteger:score],
                             @"start": startDate,
                             @"end": [NSDate date]};
  
  // get gameDataArray from NSUserDefaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *gameDataArray = [[defaults objectForKey:@"gameDataArray"] mutableCopy];
  
  // check that gameDataArray isn't nil
  if (!gameDataArray) {
    gameDataArray = [[NSMutableArray alloc] init];
  }
  
  // add game dictionary to gameDataArray
  [gameDataArray addObject:gameData];
  
  // sort gameDataArray by key "score"
  [gameDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    
    NSInteger score1 = [[obj1 objectForKey:@"score"] integerValue];
    NSInteger score2 = [[obj2 objectForKey:@"score"] integerValue];
    
    if ( score1 < score2 ) {
      return (NSComparisonResult)NSOrderedDescending;
    } else if ( score1 > score2 ) {
      return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
    
  }];
  
  // if gameDataArray has more than 15 scores, trim it
  if ( [gameDataArray count] > MAX_NUM_SAVED_SCORES ) {
     gameDataArray = [[gameDataArray subarrayWithRange:NSMakeRange(0, MAX_NUM_SAVED_SCORES)] mutableCopy];
  }
  
  // save updated gameDataArray to NSUserDefaults
  [defaults setObject:gameDataArray forKey:@"gameDataArray"];
}

@end
