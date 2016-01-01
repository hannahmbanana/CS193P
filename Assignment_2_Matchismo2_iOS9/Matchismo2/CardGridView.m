//
//  CardGridView.m
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "CardGridView.h"

@implementation CardGridView
{
  NSUInteger  _columnCount;
  NSUInteger  _rowCount;
  CGFloat     _cardWidth;
  CGFloat     _cardHeight;
  CGFloat     _cardBuffer;

}

@synthesize cardButtonArray = _cardButtonArray;

#pragma mark - Lifecycle

- (instancetype) initWithColumns:(NSUInteger)columnCount
                            rows:(NSUInteger)rowCount
{
  self = [super init];
  
  if (self) {
    
    _columnCount = columnCount;
    _rowCount = rowCount;
    
    NSMutableArray *cardButtonArray = [[NSMutableArray alloc] init];
    
    // add columnCount * rowCount number of buttons to the cardButtonArray
    for (int i = 0; i < _columnCount * _rowCount; i++) {
      
      // initialize & configure the card button
      UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [btn setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
      
      // set the btn's target action pair
      // FIXME: THIS TECHNICALLY WORKS, due to the responder chain
      // BUT [self super] will return nil here
      [btn addTarget:[self superview]
              action:@selector(touchCardButton:)
    forControlEvents:UIControlEventTouchUpInside];
      
      // add the button to the cardButtonArray & to the UIView
      [cardButtonArray addObject:btn];
      [self addSubview:btn];
      
      _cardButtonArray = cardButtonArray;
      
      [self setNeedsLayout]; //FIXME:
      
    }
    
  }
  
  return self;
}


#pragma mark - Layout

static const float HORIZONTAL_INSET = 20;
static const float VERTICAL_INSET = 40;
static const float CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH = 0.2;

// FIXME: auto layout
//static const int CARD_HEIGHT = 60;
//static const int CARD_WIDTH = 40;

- (void)layoutSubviews
{
  // determine size of cards based on size of visible screen
  CGSize visibleScreen = self.frame.size;
  NSLog(@"%f,%f", visibleScreen.width, visibleScreen.height);

  CGFloat availableCardWidth = (visibleScreen.width - 2 * HORIZONTAL_INSET);
  _cardWidth = availableCardWidth / (_columnCount + (_columnCount - 1) * CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH);
  _cardHeight = _cardWidth * 1.5;
  _cardBuffer = CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH * _cardWidth;

  for (UIButton *button in self.cardButtonArray) {
    
    NSUInteger buttonIndex = [self.cardButtonArray indexOfObject:button];
    NSUInteger cardColumnPosition = buttonIndex % _columnCount;
    NSUInteger cardRowPosition = buttonIndex / _columnCount;
    
    CGFloat xPosition = HORIZONTAL_INSET + cardColumnPosition * _cardWidth +
                        cardColumnPosition * _cardBuffer;
    
    CGFloat yPosition = VERTICAL_INSET + cardRowPosition * _cardHeight +
                        cardRowPosition * _cardBuffer;
    
    button.frame = CGRectMake(xPosition, yPosition, _cardWidth, _cardHeight);
    
  }
}

// override superclass method
- (CGSize)sizeThatFits:(CGSize)size
{
  CGFloat width = _columnCount * _cardWidth + (_columnCount - 1) * _cardBuffer +
                  HORIZONTAL_INSET * 2;
  CGFloat height = _rowCount * _cardHeight + (_rowCount - 1) * _cardBuffer +
                   VERTICAL_INSET * 2;
  
  return CGSizeMake(width,height);
}

@end
