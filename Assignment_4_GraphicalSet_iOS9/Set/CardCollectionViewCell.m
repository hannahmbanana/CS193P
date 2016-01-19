//
//  CardCollectionViewCell.m
//  Set
//
//  Created by Hannah Troisi on 1/17/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "CardCollectionViewCell.h"
#import "PlayingCard.h"
#import "SetCard.h"
#import "PlayingCardView.h"
#import "SetCardView.h"


@implementation CardCollectionViewCell
{
  BOOL        _cardFrontShowing;
  CardView    *_cardFrontView;
  UIImageView *_cardBackView;
}


#pragma mark - Properties

- (void)setCard:(Card *)card
{
  _card = card;

  [self updateCardFaceViews];
  
  // subscribe to card changes's notification
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardMatched) name:CardMatchedNotification object:_card];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardChosen) name:CardChosenNotification object:_card];

}


#pragma mark - Lifecycle

//- (instancetype)init
//{
//  self = [super initWithFrame:CGRectZero];
//  if (self) {
//  }
//  return self;
//}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _cardBackView.frame = self.contentView.bounds;
  _cardFrontView.frame = self.contentView.bounds;
}


#pragma mark - Helper Methods

- (void)updateCardFaceViews
{
  // remove existing views from the contentView, but don't destroy them if they exist, since we can reuse them.
  // they might not exist at this point, and we could be messaging nil, but that's fine.
  [_cardFrontView removeFromSuperview];
  [_cardBackView removeFromSuperview];
  
  if ( [_card isKindOfClass:[PlayingCard class]] ) {      // FIXME: inspection is EXPENSIVE, change to class method
    _cardFrontShowing = _card.chosen;
    
    if (!_cardBackView) {
      _cardBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardback"]]; // FIXME: move to layoutSubviews
    }
    
    if (!_cardFrontView) {
      _cardFrontView = [[PlayingCardView alloc] initWithFrame:CGRectZero];
    }
  
  } else if ( [_card isKindOfClass:[SetCard class]] ) {   // FIXME: inspection is EXPENSIVE, change to class method
    _cardFrontShowing = YES;

    // no face down card view for set game
    if (!_cardFrontView) {
      _cardFrontView = [[SetCardView alloc] initWithFrame:CGRectZero];
    }
  }
  
  // Regardless of the specific type of card or card view, we can set it with one line.
  [_cardFrontView setCard:_card];
  
  if (_cardFrontShowing) {
    [self.contentView addSubview:_cardFrontView];
  } else {
    [self.contentView addSubview:_cardBackView];
  }
}

- (void)cardChosen
{
  // only playing cards
  if (_cardBackView) {
    UIView *oldView = _cardFrontShowing ? _cardFrontView : _cardBackView;
    UIView *newView = _cardFrontShowing ? _cardBackView  : _cardFrontView;
    _cardFrontShowing = !_cardFrontShowing;
      
    // flip transition
    [UIView transitionFromView:oldView
                        toView:newView
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                    completion:^(BOOL finished) {}];
  } else {
    [_cardFrontView updateCardProperties];
  }
}

- (void)cardMatched
{
  // matched or chosen
  [_cardFrontView updateCardProperties];
}

- (void)fadeIn
{
  if (_cardFrontShowing) {
    _cardFrontView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{ _cardFrontView.alpha = 1; }];
  } else {
    _cardBackView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{ _cardBackView.alpha = 1; }];
  }
}


@end
