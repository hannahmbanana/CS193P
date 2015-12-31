//
//  ViewController.m
//  Matchismo
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"

@interface ViewController ()

@property (nonatomic, strong) Deck      *deck;  // our Model
@property (nonatomic, strong) UILabel   *flipsLabel;
@property (nonatomic, strong) UIButton  *cardButton;
@property (nonatomic)         int       flipCount;

@end

@implementation ViewController

@synthesize deck = _deck;
@synthesize flipsLabel = _flipsLabel;
@synthesize cardButton = _cardButton;
@synthesize flipCount = _flipCount;

#pragma mark - Properties

// override the getter for deck - lazy instantiation
- (Deck *)deck
{
  if (!_deck) {
    _deck = [[PlayingCardDeck alloc] init];
  }
  
  return _deck;
}

// override the setter for flipsCount to
- (void)setFlipCount:(int)flipCount
{
  _flipCount = flipCount;
  
  // anytime the flipCount property changes, update the flipsLable
  self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    _flipsLabel = [[UILabel alloc] init];
    _cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flipCount = 0;
  }
  
  return self;
}

#define CARD_WIDTH 64
#define CARD_HEIGHT 96
- (void)viewDidLoad
{
  self.flipsLabel.text = @"Flips: 0";
  
  [self.cardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                             forState:UIControlStateNormal];
  [self.cardButton addTarget:self
                      action:@selector(touchCardButton)
            forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.flipsLabel];
  [self.view addSubview:self.cardButton];
}

- (void)viewWillLayoutSubviews
{
  CGSize visibleWindowSize = self.view.frame.size;
  
  self.flipsLabel.frame = CGRectMake(20,
                                     visibleWindowSize.height - 40,
                                     visibleWindowSize.width - 80,
                                     20);
  
  self.cardButton.frame = CGRectMake((visibleWindowSize.width - CARD_WIDTH)/2,
                                     (visibleWindowSize.height - CARD_HEIGHT)/2,
                                     CARD_WIDTH,
                                     CARD_HEIGHT);
}

#pragma mark - UI Events

- (void)touchCardButton
{
  // "flip" to show card back
  if ([self.cardButton.currentTitle length]) {
    
    [self.cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                               forState:UIControlStateNormal];
    
    [self.cardButton setTitle:@"" forState:UIControlStateNormal];
    
    self.flipCount++;
  }
  
  // "flip" to show card front
  else {
    
    // check if there are any cards left in the deck
    Card *nextCard = [self.deck drawRandomCard];
    
    if (nextCard) {
            
      [self.cardButton setBackgroundImage:[UIImage imageNamed:@"cardFront"]
                                 forState:UIControlStateNormal];
      
      [self.cardButton setTitle:nextCard.contents forState:UIControlStateNormal];
      
      self.flipCount++;
    }
    
    // if not cards left in deck, remove cards from view
    else {
      self.cardButton.hidden = YES;
    }
  }
}

@end