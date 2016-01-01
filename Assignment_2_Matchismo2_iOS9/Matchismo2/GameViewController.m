//
//  GameViewController.m
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "GameViewController.h"
#import "CardGridView.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

static const int CARD_GRID_COL_COUNT = 6;
static const int CARD_GRID_ROW_COUNT = 5;

@interface GameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation GameViewController
{
  CardGridView *_cardGridView;
  UILabel *_scoreLabel;
  UILabel *_gameCommentaryLabel;
  UIButton *_dealButton;
}

@synthesize game = _game;

#pragma mark - Override Getters/Setters

// lazy instantiation for _game so that we can set it to nil when redealing
- (CardMatchingGame *)game
{
  if (!_game) {
    _game = [[CardMatchingGame alloc]
             initWithCardCount:CARD_GRID_COL_COUNT*CARD_GRID_ROW_COUNT
             usingDeck:[[PlayingCardDeck alloc] init]];
  }
  
  return _game;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // construct scoreLabel
  _scoreLabel = [[UILabel alloc] init];
  _scoreLabel.text = @"Score = 0";
  _scoreLabel.textColor = [UIColor whiteColor];
  _scoreLabel.font = [UIFont systemFontOfSize:15];
  
  // construct gameCommentaryLabel
  _gameCommentaryLabel = [[UILabel alloc] init];
  _gameCommentaryLabel.textAlignment = NSTextAlignmentCenter;
  _gameCommentaryLabel.textColor = [UIColor whiteColor];
  _gameCommentaryLabel.numberOfLines = 2;
  _gameCommentaryLabel.font = [UIFont systemFontOfSize:15];
  
  // construct dealButton
  _dealButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_dealButton setImage:[self backgroundImageForDealButton]
               forState:UIControlStateNormal];
  [_dealButton addTarget:self
                  action:@selector(touchDealButton)
        forControlEvents:UIControlEventTouchUpInside];
  [_dealButton setTintColor:[UIColor whiteColor]];
  
  // add subviews to view
  _cardGridView = [[CardGridView alloc] initWithColumns:CARD_GRID_COL_COUNT
                                                   rows:CARD_GRID_ROW_COUNT];
  [self.view addSubview:_cardGridView];
  
  [self.view addSubview:_scoreLabel];
  [self.view addSubview:_gameCommentaryLabel];
  [self.view addSubview:_dealButton];
  
  [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillLayoutSubviews
{
  _cardGridView.frame = self.view.frame;
  [_cardGridView layoutSubviews]; //FIXME: WHY DO I NEED THIS???
  
  // set frames for subviews
  [_cardGridView sizeToFit];
  NSLog(@"sizing to fit");
  
  CGRect cardGridViewFrame = _cardGridView.frame;
  cardGridViewFrame.origin = CGPointZero;
  _cardGridView.frame = cardGridViewFrame;
  
  CGRect scoreLabelFrame = CGRectMake(20,
                                      self.view.bounds.size.height - 40,
                                      self.view.bounds.size.width - 40,
                                      20);
  _scoreLabel.frame = scoreLabelFrame;
  
  CGRect gameCommentaryLabelFrame = CGRectMake(20,
                                               _cardGridView.frame.size.height,
                                               self.view.bounds.size.width - 40,
                                               60);
  _gameCommentaryLabel.frame = gameCommentaryLabelFrame;
  
  
  [_dealButton sizeToFit];
  CGRect dealButtonFrame = _dealButton.frame;
  dealButtonFrame.origin = CGPointMake(self.view.bounds.size.width - 60,
                                       self.view.bounds.size.height - 44);
  _dealButton.frame = dealButtonFrame;
}

#pragma mark - UIView actions

- (void)touchDealButton
{
  self.game = nil;
  
  // update UI
  [self updateUI];
}

- (void)touchCardButton:(UIButton *)sender
{
  // find index of button pressed
  NSUInteger cardButtonIndex = [_cardGridView.cardButtonArray
                                indexOfObject:sender];
  
  // update game model
  [self.game choseCardAtIndex:cardButtonIndex];
  
  // update UI
  [self updateUI];
}

#pragma mark - Helper Methods

- (void)updateUI
{
  // for each card
  for (UIButton *cardButton in _cardGridView.cardButtonArray) {
    
    // get card corresponding to UIButton
    NSUInteger cardButtonIndex = [_cardGridView.cardButtonArray
                                  indexOfObject:cardButton];
    
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    
    // update button image
    [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                          forState:UIControlStateNormal];
    
    // update button title
    [cardButton setTitle:[self titleForCard:card]
                forState:UIControlStateNormal];
    
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
  _scoreLabel.text = [NSString stringWithFormat:@"Score = %ld",(long)self.game.score];
  
  // update game commentary
  NSMutableString *label = [NSMutableString string];
  for (Card *card in self.game.lastMatched) {
    [label appendString:card.contents];
  }
  
  // 2 cards case
  if ([self.game.lastMatched count] > 1) {
    
    if (self.game.lastScore < 0) {
      [label appendFormat:@" don't match.\n%ld point penalty.", (long)self.game.lastScore];
    } else {
      [label appendFormat:@" matched for %ld points!", (long)self.game.lastScore];
    }
  }
  
  _gameCommentaryLabel.text = label;
  
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

- (UIImage *)backgroundImageForDealButton
{
  NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor]};
  
  NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:@"Deal"
                                                                    attributes:attributes];
  // returns the minimum size required to draw the contents of the string
  CGSize textSize = [titleString size];
  
  // sizing for roundedRect
  CGFloat cornerRadius = 5.0;
  CGFloat lineWidth = 1.0;
  CGFloat padding = (lineWidth + cornerRadius) * 2;
  
  CGSize bufferSize = CGSizeMake(textSize.width + padding,
                                 textSize.height + padding);
  
  CGRect roundRect = CGRectMake(0,0,bufferSize.width,bufferSize.height);
  
  CGPoint titleOrigin = CGPointMake((roundRect.size.height - textSize.height)/2.0,
                                    (roundRect.size.height - textSize.height)/2.0);
  
  UIGraphicsBeginImageContextWithOptions(bufferSize, NO, 0.0);
  [[UIColor whiteColor] set];         // sets stroke & fill
  [[UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:cornerRadius] stroke];
  [titleString drawAtPoint:titleOrigin];
  
  UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return buttonImage;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

@end
