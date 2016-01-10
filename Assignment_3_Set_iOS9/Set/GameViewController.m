//
//  GameViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "GameViewController.h"
#import "GameHistoryViewController.h"

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

// lazy instantiation for _gameCommentaryHistory so that we can set it to nil when dealing
- (NSMutableAttributedString *)gameCommentaryHistory
{
  if (!_gameCommentaryHistory) {
    _gameCommentaryHistory = [[NSMutableAttributedString alloc] init];
  }
  
  return _gameCommentaryHistory;
}


#pragma mark - Lifecycle

- (instancetype)initWithColumnCount:(NSUInteger)numCols rowCount:(NSUInteger)numRows
{
  self = [super initWithNibName:nil bundle:nil];
  
  if (self) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Play History"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(touchHistoryButton)];
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
  
  // create gameCommentaryLabel
  self.gameCommentaryLabel = [[UILabel alloc] init];
  self.gameCommentaryLabel.textAlignment = NSTextAlignmentCenter;
  self.gameCommentaryLabel.numberOfLines = 0;
  
  // create dealButton
  self.dealButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.dealButton setImage:[self backgroundImageForDealButton] forState:UIControlStateNormal];
  [self.dealButton addTarget:self action:@selector(touchDealButton) forControlEvents:UIControlEventTouchUpInside];
  [self.dealButton setTintColor:[UIColor whiteColor]];
  
  // create & update buttonGridView
  self.buttonGridView = [[ButtonGridView alloc] initWithColumns:_colCount rows:_rowCount delegate:self];
  [self updateUI];

  // add subviews to view
  [self.view addSubview:self.buttonGridView];
  [self.view addSubview:self.scoreLabel];
  [self.view addSubview:self.gameCommentaryLabel];
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
  
  // set frame for gameCommentaryLabel
  [self.gameCommentaryLabel sizeToFit];

  CGRect gameCommentaryLabelFrame = self.gameCommentaryLabel.frame;
  gameCommentaryLabelFrame.size = [self.gameCommentaryLabel sizeThatFits:CGSizeMake(boundsSize.width, CGFLOAT_MAX)];
  gameCommentaryLabelFrame.origin = CGPointMake(roundf((boundsSize.width - gameCommentaryLabelFrame.size.width) / 2),
                                                CGRectGetMaxY(self.buttonGridView.frame));
  self.gameCommentaryLabel.frame = gameCommentaryLabelFrame;
  
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
  // remove current game & gameCommentary History
  self.game = nil;
  self.gameCommentaryHistory = nil;
  
  // update UI
  [self updateUI];
}

- (void)touchHistoryButton
{
  GameHistoryViewController *historyViewController = [[GameHistoryViewController alloc]
                                                      initWithPlayHistoryString:self.gameCommentaryHistory];
  
  [self.navigationController pushViewController: historyViewController animated:YES];
}


#pragma mark - Instance Methods

- (void)updateUI
{
  // updates cardButton title, background image, enabled, alpha, shadow
  [self.buttonGridView updateBtnCards];
  
  // update game score
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
  
  // update game commentary label
  NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] init];
  
  // display the title of the currently selected cards in the label
  for (Card *card in self.game.lastMatched) {
    
    // create a UIImage of the card's attributed title string
    NSAttributedString *attributedCardString = [self attributedTitleForCard:card overrideIsChosenCheck:YES];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [self imageFromString:attributedCardString];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    // append the card's UIImage attributed title string to the label
    [labelString appendAttributedString:attrStringWithImage];
  }
  
  // append any game commentary to the label
  if ([self.game.lastMatched count] > [[self class] numCardsInMatch] - 1) {
    
    NSString *commentary;
    
    // come up with game commentary
    if (self.game.lastScore < 0) {
      commentary = [NSString stringWithFormat:@"\n are not a match (%ld points)\n\n", (long)self.game.lastScore];
    } else {
      commentary = [NSString stringWithFormat:@"\n match (+%ld points)!\n\n", (long)self.game.lastScore];
    }
    
    // append the game commentary to the label
    [labelString appendAttributedString:[[NSAttributedString alloc] initWithString:commentary
                                                                        attributes:[[self class] attributesDictionary]]];
    
    // append the current label to the gameCommentaryHistory
    [self.gameCommentaryHistory appendAttributedString:labelString];
    
  } else if ([self.game.lastMatched count]) {
    [labelString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
  }
  
  // update game commentary label
  self.gameCommentaryLabel.attributedText = labelString;
  
  // refresh view
  [self.view setNeedsLayout];

}

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


#pragma mark - ButtonGridViewDelegate Methods

- (void)touchCardButtonAtIndex:(NSUInteger)cardButtonIndex
{
  // update game model
  [self.game choseCardAtIndex:cardButtonIndex];
  
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
  return nil;
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
