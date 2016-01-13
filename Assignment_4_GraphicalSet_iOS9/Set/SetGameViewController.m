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
#import "SetCardGrid.h"
#import <QuartzCore/QuartzCore.h>

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

+ (Class)cardGridClass
{
  return [SetCardGrid class];
}

+ (NSUInteger)numCardsInMatch
{
  return 3;
}


#pragma mark - Lifecycle

- (instancetype)initWithColumnCount:(NSUInteger)numCols rowCount:(NSUInteger)numRows
{
  self = [super initWithColumnCount:numCols rowCount:numRows];
  if (self) {
    
    // set navigation title
    self.navigationItem.title = @"Classic Set";
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


#pragma mark - Helper Methods

- (void)dealThreeCards
{
  NSLog(@"HI");
}


#pragma mark - ButtonGridViewDelegate Methods

- (NSAttributedString *)attributedTitleForCard:(Card *)setCard overrideIsChosenCheck:(BOOL)override
{
  SetCard *card = (SetCard *)setCard;
  
  // set attributes for card's color
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:card.color forKey:NSForegroundColorAttributeName];

  // set attributes for card's fill
  if ([card.shade isEqualToString:@"solid"]) {
    [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];

  } else if ([card.shade isEqualToString:@"striped"]) {
    [attributes addEntriesFromDictionary:@{ NSStrokeWidthAttributeName      : @-5,
                                            NSStrokeColorAttributeName      : attributes[NSForegroundColorAttributeName],
                                            NSForegroundColorAttributeName  : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.3]}];

  } else if ([card.shade isEqualToString:@"open"]) {
    [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
  }

  // create the correct string for card's number, shape
  NSMutableString *numberShapeString = [[NSMutableString alloc] init];
  for (int i = 1; i <= card.number; i++) {
    [numberShapeString appendString:card.shape];
    if (i != card.number) {
      [numberShapeString appendString:@"\n"];
    }
  }

  // create the attributed string
  NSAttributedString *title = [[NSAttributedString alloc] initWithString:[numberShapeString copy] attributes:attributes];

  return title;
}

- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)cardButtonIndex
{
  return [UIImage imageNamed:@"cardfront"];
}

- (BOOL)shadowForCardAtIndex:(NSUInteger)cardButtonIndex;
{
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  
  if (card.isChosen && !card.isMatched) {
    return YES;
  } else {
    return NO;
  }
}

@end
