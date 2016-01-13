//
//  GameViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController () <ButtonGridViewDelegate>
@end

@implementation GameViewController
{
  NSUInteger _colCount;
  NSUInteger _rowCount;
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
+ (Class)cardGridClass
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

+ (NSDictionary *)attributesDictionary
{
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setAlignment:NSTextAlignmentCenter];
  
  NSDictionary *attributes = @{ NSForegroundColorAttributeName  : [UIColor whiteColor],
                                NSFontAttributeName             : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                NSParagraphStyleAttributeName   : paragraphStyle};
  return attributes;
}


#pragma mark - Properties

// lazy instantiation for _game so that we can set it to nil when dealing
- (MatchingGame *)game
{
  if (!_game) {
    Deck *deck = [[[[self class] deckClass] alloc] init];
    _game = [[[[self class] gameClass] alloc] initWithCardCount:_colCount * _rowCount usingDeck:deck];
  }
  
  return _game;
}


#pragma mark - Lifecycle

- (instancetype)initWithColumnCount:(NSUInteger)numCols rowCount:(NSUInteger)numRows
{
  self = [super initWithNibName:nil bundle:nil];
  
  if (self) {
    _colCount = numCols;
    _rowCount = numRows;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // create scoreLabel
  self.scoreLabel = [[UILabel alloc] init];
  self.scoreLabel.text = @"Score: 0";
  self.scoreLabel.textColor = [UIColor whiteColor];
  self.scoreLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  
  // create dealButton
  self.dealButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.dealButton setImage:[self backgroundImageForDealButton] forState:UIControlStateNormal];
  [self.dealButton addTarget:self action:@selector(touchDealButton) forControlEvents:UIControlEventTouchUpInside];
  [self.dealButton setTintColor:[UIColor whiteColor]];
  
  // create & update buttonGridView
  self.buttonGridView = [[[[self class] cardGridClass] alloc] initWithColumns:_colCount rows:_rowCount delegate:self game:self.game];
  [self updateUI];

  // add subviews to view
  [self.view addSubview:self.buttonGridView];
  [self.view addSubview:self.scoreLabel];
  [self.view addSubview:self.dealButton];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  CGSize boundsSize = self.view.bounds.size;
  
  // set frame for buttonGridView
  self.buttonGridView.frame = (CGRect){ CGPointMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)),
                                        [self.buttonGridView preferredSizeForWidth:boundsSize.width] };
  
  // set frame for scoreLabel
  self.scoreLabel.frame = CGRectMake(20,
                                     self.view.bounds.size.height - 40 - 54,
                                     self.view.bounds.size.width - 40,
                                     20);
  
  // set frame for dealButton
  [self.dealButton sizeToFit];
  CGRect dealButtonFrame = self.dealButton.frame;
  dealButtonFrame.origin = CGPointMake(self.view.bounds.size.width - 60,
                                       self.view.bounds.size.height - 44 - 54);
  self.dealButton.frame = dealButtonFrame;
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
  
  // update UI
  [self updateUI];
}


#pragma mark - Instance Methods

// subclass must implement
- (NSAttributedString *)attributedTitleForCard:(Card *)card overrideIsChosenCheck:(BOOL)shouldOverride
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return nil;
}

- (BOOL)cardMatchedAtIndex:(NSUInteger)cardButtonIndex
{
  return [[self.game cardAtIndex:cardButtonIndex] isMatched];
}

- (void)updateUI
{
  // updates cardButton title, background image, enabled, alpha, shadow
  for (Card *card in self.game.cards) {
    NSUInteger cardIndex = [self.game.cards indexOfObject:card];
    [self.buttonGridView updateCardAtIndex:cardIndex withCard:card];
  }
  
  // update game score
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
  
  // refresh view
  [self.view setNeedsLayout];
  
}


#pragma mark - ButtonGridViewDelegate Methods

- (void)touchCardButtonAtIndex:(NSUInteger)cardButtonIndex
{
  // update game model
  [self.game choseCardAtIndex:cardButtonIndex];
  
  // have cardGrid update that card's view
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  [self.buttonGridView updateCardAtIndex:cardButtonIndex withCard:card];
  
  // update UI
  [self updateUI];
}

- (NSAttributedString *)attributedTitleForCardAtIndex:(NSUInteger)cardButtonIndex;
{
  Card *card = [self.game cardAtIndex:cardButtonIndex];

  return [self attributedTitleForCard:card overrideIsChosenCheck:NO];
}

// subclass must implement
- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)index;
{
  return nil;
}

// subclass must implement
- (BOOL)shadowForCardAtIndex:(NSUInteger)index
{
  return NO;
}

- (BOOL)enableCardAtIndex:(NSUInteger)cardButtonIndex
{
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  
  return card.isMatched ? NO : YES;
}

- (CGFloat)alphaForCardAtIndex:(NSUInteger)cardButtonIndex
{
  return [self enableCardAtIndex:cardButtonIndex] ? 1.0 : 0.4;
}


#pragma mark - NSUser Defaults

static const int MAX_NUM_SAVED_SCORES = 11;

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


#pragma mark - Helper Drawing Methods

- (UIImage *)imageFromString:(NSAttributedString *)string
{
  // returns the minimum size required to draw the contents of the string
  CGSize stringSize = [string size];
  
  // create a CGContext with the correct buffer size
  UIGraphicsBeginImageContextWithOptions(stringSize, NO, 0);
  
  // draw the string
  [string drawInRect:CGRectMake(0, 0, stringSize.width, stringSize.height)];
  
  // get an image from the current CGContext
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  
  // end the context
  UIGraphicsEndImageContext();
  
  return image;
}

- (UIImage *)backgroundImageForDealButton
{
  NSAttributedString *dealBtnTitle = [[NSAttributedString alloc] initWithString:@"Deal"
                                                                    attributes:[[self class] attributesDictionary]];
  
  // returns the minimum size required to draw the contents of the string
  CGSize textSize = [dealBtnTitle size];
  
  // sizing for roundedRect
  CGFloat cornerRadius = 5.0;
  CGFloat lineWidth = 1.0;
  CGFloat padding = (lineWidth + cornerRadius) * 2;
  
  CGSize bufferSize     = CGSizeMake(textSize.width + padding, textSize.height + padding);
  CGRect roundRectRect  = CGRectMake(0, 0, bufferSize.width, bufferSize.height);
  CGPoint titleOrigin   = CGPointMake((roundRectRect.size.height - textSize.height)/2.0,
                                      (roundRectRect.size.height - textSize.height)/2.0);
  
  // create a CGContext with the correct buffer size
  UIGraphicsBeginImageContextWithOptions(bufferSize, NO, 0);
  
  // set stroke & fill
  [[UIColor whiteColor] set];
  
  // draw rounded rect bezier path
  [[UIBezierPath bezierPathWithRoundedRect:roundRectRect cornerRadius:cornerRadius] stroke];
  
  // draw title
  [dealBtnTitle drawAtPoint:titleOrigin];
  
  // get an image from the current CGContext
  UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // end the context
  UIGraphicsEndImageContext();
  
  return buttonImage;
}

@end
