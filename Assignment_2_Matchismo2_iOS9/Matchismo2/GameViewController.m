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

@implementation GameViewController    // Question: should these be properties instead of instance vars?
{
  CardGridView        *_cardGridView;
  UILabel             *_scoreLabel;
  UILabel             *_gameCommentaryLabel;
  UIButton            *_dealButton;
  UISegmentedControl  *_gameModeSegmentedControl;
}

@synthesize game = _game;


#pragma mark - Properties

// lazy instantiation of _game so that we can set it to nil when the _dealButton is pressed
- (CardMatchingGame *)game
{
  if (!_game) {
    _game = [[CardMatchingGame alloc] initWithCardCount:CARD_GRID_COL_COUNT*CARD_GRID_ROW_COUNT
                                              usingDeck:[[PlayingCardDeck alloc] init]];
  }
  
  return _game;
}


#pragma mark - Lifecycle

- (void)viewDidLoad   // Question: should some of this code live in init?
{
  [super viewDidLoad];
  
  // intialize & configure scoreLabel
  _scoreLabel = [[UILabel alloc] init];
  _scoreLabel.text = @"Score = 0";
  _scoreLabel.textColor = [UIColor whiteColor];
  _scoreLabel.font = [UIFont systemFontOfSize:15];
  
  // intialize & configure gameCommentaryLabel
  _gameCommentaryLabel = [[UILabel alloc] init];
  _gameCommentaryLabel.textAlignment = NSTextAlignmentCenter;
  _gameCommentaryLabel.textColor = [UIColor whiteColor];
  _gameCommentaryLabel.font = [UIFont systemFontOfSize:15];
  _gameCommentaryLabel.numberOfLines = 2;
  
  // intialize & configure dealButton
  _dealButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_dealButton setImage:[self backgroundImageForDealButton] forState:UIControlStateNormal];
  [_dealButton addTarget:self action:@selector(touchDealButton) forControlEvents:UIControlEventTouchUpInside];
  [_dealButton setTintColor:[UIColor whiteColor]];
  
  // intialize & configure gameModeSegmentedControl
  _gameModeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"2", @"3"]];
  _gameModeSegmentedControl.selectedSegmentIndex = 0;
  self.game.gameCardModeMaxCards = 2;
  _gameModeSegmentedControl.tintColor = [UIColor whiteColor];
  [_gameModeSegmentedControl addTarget:self action:@selector(touchGameModeSegmentedControl:)
                      forControlEvents:UIControlEventTouchUpInside];
  
  // initialize & configure the cardGridView
  _cardGridView = [[CardGridView alloc] initWithColumns:CARD_GRID_COL_COUNT rows:CARD_GRID_ROW_COUNT];
  
  // add subviews
  [self.view addSubview:_scoreLabel];
  [self.view addSubview:_gameCommentaryLabel];
  [self.view addSubview:_dealButton];
  [self.view addSubview:_gameModeSegmentedControl];
  [self.view addSubview:_cardGridView];
  
  // needed to make the status bar white
  [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillLayoutSubviews
{
  CGSize boundsSize = self.view.bounds.size;
  
  // set frames for subviews
  _cardGridView.frame = (CGRect){CGPointZero, [_cardGridView preferredSizeForWidth:boundsSize.width]};
  
  CGRect scoreLabelFrame = CGRectMake(20, boundsSize.height - 40, boundsSize.width - 40, 20);
  _scoreLabel.frame = scoreLabelFrame;
  
  CGRect gameCommentaryLabelFrame = CGRectMake(20, _cardGridView.frame.size.height, boundsSize.width - 40, 60);
  _gameCommentaryLabel.frame = gameCommentaryLabelFrame;
  
  [_dealButton sizeToFit];
  CGRect dealButtonFrame = _dealButton.frame;
  dealButtonFrame.origin = CGPointMake(boundsSize.width - 60, boundsSize.height - 44);
  _dealButton.frame = dealButtonFrame;
  
  [_gameModeSegmentedControl sizeToFit];
  CGRect gameModeSegmentedControlFrame = _gameModeSegmentedControl.frame;
  gameModeSegmentedControlFrame.origin =
                CGPointMake(_dealButton.frame.origin.x - _gameModeSegmentedControl.frame.size.width - 10,
                CGRectGetMaxY(_dealButton.frame) - _gameModeSegmentedControl.frame.size.height);
  _gameModeSegmentedControl.frame = gameModeSegmentedControlFrame;
}


#pragma mark - UIView actions

- (void)touchDealButton
{
  self.game = nil;
  
  // enable _gameModeSegmentedControl
  _gameModeSegmentedControl.enabled = YES;
  
  // update UI
  [self updateUI];
}

- (void)touchGameModeSegmentedControl:(UISegmentedControl *)sender
{
  NSString *maxNumCardsString = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
  
  self.game.gameCardModeMaxCards = [maxNumCardsString integerValue];
}

- (void)touchCardButton:(UIButton *)sender
{
  // find index of button pressed
  NSUInteger cardButtonIndex = [_cardGridView.cardButtonArray indexOfObject:sender];
  
  // update game model
  [self.game choseCardAtIndex:cardButtonIndex];
  
  // update UI
  [self updateUI];
  
  // disable _gameModeSegmentedControl
  _gameModeSegmentedControl.enabled = NO;
}


#pragma mark - Helper Methods

- (void)updateUI
{
  // for each card
  for (UIButton *cardButton in _cardGridView.cardButtonArray) {
    
    // get card corresponding to UIButton
    NSUInteger cardButtonIndex = [_cardGridView.cardButtonArray indexOfObject:cardButton];
    
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    
    // update button image
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    
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

- (UIImage *)backgroundImageForDealButton  // FIXME: corners aren't smooth like the UISegmentedControl rounded rect...
{
  // create "Deal" string
  NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:15.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor]};
  
  NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:@"Deal" attributes:attributes];
  CGSize textSize = [titleString size];
  
  // sizing for roundedRect
  CGFloat cornerRadius = 7.0;
  CGFloat lineWidth = 1.0;
  CGFloat padding = (lineWidth + cornerRadius) * 2;
  
  CGSize bufferSize = CGSizeMake(textSize.width + padding, textSize.height + padding);
  
  CGRect roundRect = CGRectMake(0,0,bufferSize.width,bufferSize.height);
  
  CGPoint titleOrigin = CGPointMake((roundRect.size.height - textSize.height)/2.0,
                                    (roundRect.size.height - textSize.height)/2.0);
  
  UIGraphicsBeginImageContextWithOptions(bufferSize, NO, 0.0);
  [[UIColor whiteColor] set];         // sets stroke & fill
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:cornerRadius];
  path.lineWidth = 2;
  [path stroke];
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
