//
//  ButtonGridView.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ButtonGridView.h"

@implementation ButtonGridView
{
  NSUInteger                  _columnCount;
  NSUInteger                  _rowCount;
  id<ButtonGridViewDelegate>  _delegate;
}

@synthesize cardButtonArray = _cardButtonArray;

#pragma mark - Lifecycle

+ (UIImage *)cardImage
{
  return [UIImage imageNamed:@"cardback"];
}

- (CGSize)preferredSizeForWidth:(CGFloat)width
{
  CGSize cardAssetSize = [[ButtonGridView cardImage] size];
  
  //  CGFloat actualCardWidth = width - 2 * HORIZONTAL_INSET - (_columnCount - 1)
  
  // FIXME: Revisit this to ensure spaces / gaps are accounted for, otherwise the aspect ratio transformation is wrong
  CGFloat aspectRatio = cardAssetSize.height / cardAssetSize.width;
  CGFloat height = roundf(width * aspectRatio);
  
  return CGSizeMake(width, height);
}

- (instancetype)initWithColumns:(NSUInteger)columnCount rows:(NSUInteger)rowCount delegate:(id<ButtonGridViewDelegate>)delegate;
{
  self = [super init];
  
  if (self) {
    
    _columnCount = columnCount;
    _rowCount = rowCount;
    _delegate = delegate;
    
    NSMutableArray *cardButtonArray = [[NSMutableArray alloc] init];
    
    // add columnCount * rowCount number of buttons to the cardButtonArray
    for (int i = 0; i < _columnCount * _rowCount; i++) {
      
      // initialize & configure the card button
      UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [btn setBackgroundImage:[ButtonGridView cardImage] forState:UIControlStateNormal];
      [btn addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
      
      // add the button to the cardButtonArray & to the UIView
      [cardButtonArray addObject:btn];
      [self addSubview:btn];
      
      _cardButtonArray = cardButtonArray;
    }
    
  }
  
  return self;
}


#pragma mark - Layout

static const float HORIZONTAL_INSET = 20;
static const float VERTICAL_INSET = 40;
static const float CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH = 0.2;

- (void)layoutSubviews
{
  // determine size of cards based on size of visible screen
  CGSize boundsSize = self.bounds.size;
  
  CGFloat availableCardSpan = (boundsSize.width - 2 * HORIZONTAL_INSET);
  CGSize cardAssetSize = [[ButtonGridView cardImage] size];
  CGFloat cardAspectRatio = cardAssetSize.height / cardAssetSize.width;
  
  CGFloat cardWidth = availableCardSpan / (_columnCount + (_columnCount - 1) * CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH);
  CGFloat cardHeight = roundf(cardWidth * cardAspectRatio);
  CGFloat cardBuffer = CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH * cardWidth;
  
  for (UIButton *button in _cardButtonArray) { CGRect buttonFrame = (CGRect){ CGPointZero, cardWidth, cardHeight };
    
    NSUInteger buttonIndex = [_cardButtonArray indexOfObjectIdenticalTo:button];
    NSUInteger cardColumnPosition = buttonIndex % _columnCount;
    NSUInteger cardRowPosition = buttonIndex / _columnCount;
    
    buttonFrame.origin.x = HORIZONTAL_INSET + cardColumnPosition * cardWidth + cardColumnPosition * cardBuffer;
    
    buttonFrame.origin.y = VERTICAL_INSET + cardRowPosition * cardHeight + cardRowPosition * cardBuffer;
    
    button.frame = buttonFrame;
  }
}

- (void)buttonTouched:(UIButton *)sender
{
  [_delegate touchCardButton:sender];
}

@end
