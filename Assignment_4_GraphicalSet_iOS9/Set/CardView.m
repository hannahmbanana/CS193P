//
//  CardView.m
//  CustomCards-Project4
//
//  Created by Hannah Troisi on 10/22/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "CardView.h"

@implementation CardView

@synthesize faceUp = _faceUp;


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

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self) {
    
    // UIView properties
    self.opaque = NO;
    self.backgroundColor = nil;
    self.contentMode = UIViewContentModeRedraw;
    
    // add tap gesture recognizer
    UITapGestureRecognizer *tGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCard:)];
    tGR1.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCardTwice:)];
    tGR2.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer *tGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCardThrice:)];
    tGR3.numberOfTapsRequired = 3;
    
    UITapGestureRecognizer *tGR4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCardQuarce:)];
    tGR4.numberOfTapsRequired = 4;
    
    // required otherwise e.g. 2 taps gets recognized simultaneously as both 1 and 2 taps
    [tGR1 requireGestureRecognizerToFail:tGR2];
    [tGR1 requireGestureRecognizerToFail:tGR3];
    [tGR1 requireGestureRecognizerToFail:tGR4];
    [tGR2 requireGestureRecognizerToFail:tGR3];
    [tGR2 requireGestureRecognizerToFail:tGR4];
    [tGR3 requireGestureRecognizerToFail:tGR4];
    
    [self addGestureRecognizer:tGR1];
    [self addGestureRecognizer:tGR2];
    [self addGestureRecognizer:tGR3];
    [self addGestureRecognizer:tGR4];
  }
  
  return self;
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

- (void)drawRect:(CGRect)rect
{
  // create the card shape, color & outline
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  
  [[UIColor whiteColor] set];
  [path fill];
  [path stroke];
  [path addClip];
}


#pragma mark - Gesture Recognizer

// subclass must implement
- (void)tappedCard:(UIGestureRecognizer *)gestureRecognizer
{
  NSAssert(NO, @"This should not be reached - abstract class");
}

// subclass must implement
- (void)tappedCardTwice:(UIGestureRecognizer *)gestureRecognizer
{
}

// subclass must implement
- (void)tappedCardThrice:(UIGestureRecognizer *)gestureRecognizer
{
}

// subclass must implement
- (void)tappedCardQuarce:(UIGestureRecognizer *)gestureRecognizer
{
}

@end
