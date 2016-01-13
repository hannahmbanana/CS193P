//
//  CardView.m
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//


#import "CardView.h"
#import "Card.h"

@implementation CardView


#pragma mark - Layout Class Method

#define BRIDGE_CARD_ASPECT_RATIO 1.57

+ (CGSize)preferredCardSizeForWidth:(CGFloat)width
{
  return CGSizeMake( width, roundf(width * BRIDGE_CARD_ASPECT_RATIO) );
}


#pragma mark - Properties

- (void)setFaceUp:(BOOL)faceUp
{
  _faceUp = faceUp;
  [self setNeedsDisplay];
}


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame card:(Card *)card
{
  self = [super initWithFrame:frame];
  
  if (self) {
    
    // card properties
    [self updateCardProperties:card];
    
    // UIView properties
    self.opaque = NO;
    self.backgroundColor = nil;
    self.contentMode = UIViewContentModeRedraw;
    
  }
  
  return self;
}


#pragma mark - Instance Methods

- (void)updateCardProperties:(Card *)card
{
  self.faceUp = card.chosen;
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor
{
  return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius
{
  return CORNER_RADIUS * [self cornerScaleFactor];
}

- (void)drawRect:(CGRect)rect
{
  // create the card shape, color & outline
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  
  [[UIColor whiteColor] set];
  [path fill];
  [path stroke];
  [path addClip];
}

@end
