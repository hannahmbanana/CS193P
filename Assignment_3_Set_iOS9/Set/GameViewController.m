//
//  GameViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "GameViewController.h"
#import "GameHistoryViewController.h"

// FIXME: duplicated in subclasses?
static const int CARD_GRID_COL_COUNT = 6;
static const int CARD_GRID_ROW_COUNT = 5;

@interface GameViewController () <ButtonGridViewDelegate>
@end

@implementation GameViewController

#pragma mark - Class Methods

+ (Class)gameClass
{
  return Nil;
}

#pragma mark - Properties

// lazy instantiation for _game so that we can set it to nil when dealing
- (MatchingGame *)game
{
  if (!_game) {
    _game = [[[[self class] gameClass] alloc] initWithCardCount:CARD_GRID_COL_COUNT*CARD_GRID_ROW_COUNT usingDeck:[self createDeck]];
  }
  
  return _game;
}

#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Play History"
                                                                              style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(touchHistoryButton)];
    
    _gameCommentaryHistory = [[NSMutableAttributedString alloc] init];
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.buttonGridView = [[ButtonGridView alloc]
                         initWithColumns:CARD_GRID_COL_COUNT
                         rows:CARD_GRID_ROW_COUNT
                         delegate:self];
  
  // construct scoreLabel
  self.scoreLabel = [[UILabel alloc] init];
  self.scoreLabel.text = @"Score: 0";
  self.scoreLabel.textColor = [UIColor whiteColor];
  self.scoreLabel.font = [UIFont systemFontOfSize:15];
  
  // construct gameCommentaryLabel
  self.gameCommentaryLabel = [[UILabel alloc] init];
  self.gameCommentaryLabel.textAlignment = NSTextAlignmentCenter;
  self.gameCommentaryLabel.textColor = [UIColor whiteColor];
  self.gameCommentaryLabel.numberOfLines = 4;
  self.gameCommentaryLabel.font = [UIFont systemFontOfSize:15];
  
  // construct dealButton
  self.dealButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.dealButton setImage:[self backgroundImageForDealButton]
                   forState:UIControlStateNormal];
  [self.dealButton addTarget:self
                      action:@selector(touchDealButton)
            forControlEvents:UIControlEventTouchUpInside];
  [self.dealButton setTintColor:[UIColor whiteColor]];
  
  // add subviews to view
  [self.view addSubview:self.buttonGridView];
  [self.view addSubview:self.scoreLabel];
  [self.view addSubview:self.gameCommentaryLabel];
  [self.view addSubview:self.dealButton];
}

- (void)viewWillLayoutSubviews
{
  //    // set frames for subviews
  //    [self.buttonGridView sizeToFit];
  //    CGRect buttonGridViewFrame = self.buttonGridView.frame;
  //    buttonGridViewFrame.origin = CGPointMake(0,44);
  //    self.buttonGridView.frame = buttonGridViewFrame;
  
  CGSize boundsSize = self.view.bounds.size;
  
  // set frames for subviews
  self.buttonGridView.frame = (CGRect){CGPointMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame)),
                                      [self.buttonGridView preferredSizeForWidth:boundsSize.width]};
  
  
  CGRect scoreLabelFrame = CGRectMake(20,
                                      self.view.bounds.size.height - 40 - 54,
                                      self.view.bounds.size.width - 40,
                                      20);
  self.scoreLabel.frame = scoreLabelFrame;
  
  CGRect gameCommentaryLabelFrame = CGRectMake(20,
                                               CGRectGetMaxY(self.buttonGridView.frame),
                                               boundsSize.width - 40,
                                               60);

  self.gameCommentaryLabel.frame = gameCommentaryLabelFrame;
  self.gameCommentaryLabel.backgroundColor = [UIColor purpleColor];
  
  
  [self.dealButton sizeToFit];
  CGRect dealButtonFrame = self.dealButton.frame;
  dealButtonFrame.origin = CGPointMake(self.view.bounds.size.width - 60,
                                       self.view.bounds.size.height - 44 - 54);
  self.dealButton.frame = dealButtonFrame;
  
  [self updateUI];
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
  NSUInteger cardButtonIndex = [self.buttonGridView.cardButtonArray indexOfObject:sender];
  
  // update game model
  [self.game choseCardAtIndex:cardButtonIndex];
  
  // update UI
  [self updateUI];
}

- (void)touchHistoryButton
{
  GameHistoryViewController *historyViewController = [[GameHistoryViewController alloc]
                                                      initWithPlayHistoryString:self.gameCommentaryHistory];
  [self.navigationController pushViewController: historyViewController animated:YES];
}

#pragma mark - Helper Methods

// SUBCLASS MUST IMPLEMENT
- (void) updateUI
{
}

// SUBCLASS MUST IMPLEMENT
- (Deck *)createDeck
{
  return nil;
}

- (UIImage *)backgroundImageForDealButton
{
  NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:15.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor]};
  
  NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:@"Deal"
                                                                    attributes:attributes];
  // returns the minimum size required to draw the contents of the string
  CGSize textSize = [titleString size];
  
  // sizing for roundedRect
  CGFloat cornerRadius = 5.0;
  CGFloat lineWidth = 1.0;
  CGFloat padding = (lineWidth + cornerRadius) * 2;
  
  CGSize bufferSize = CGSizeMake(textSize.width + padding, textSize.height + padding);
  
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

@end
