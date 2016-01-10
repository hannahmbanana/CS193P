//
//  ButtonGridView.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ButtonGridView.h"

typedef struct CardLayoutInfo {
  CGFloat  cardHeight;
  CGFloat  cardWidth;
  CGFloat  cardBuffer;
  CGFloat  gridHeight;
  CGFloat  gridWidth;
} CardLayoutInfo;


@implementation ButtonGridView
{
  NSMutableArray              *_cardButtonArray;
  NSUInteger                  _columnCount;
  NSUInteger                  _rowCount;
  id<ButtonGridViewDelegate>  _delegate;
}


#pragma mark - Lifecycle

- (instancetype)initWithColumns:(NSUInteger)columnCount
                           rows:(NSUInteger)rowCount
                       delegate:(id<ButtonGridViewDelegate>)delegate;
{
  self = [super initWithFrame:CGRectZero];
  
  if (self) {
    
    // create and configure instance variables
    _cardButtonArray = [[NSMutableArray alloc] init];
    _columnCount = columnCount;
    _rowCount = rowCount;
    _delegate = delegate;
    
    // add columnCount * rowCount number of buttons to the cardButtonArray
    for (int i = 0; i < _columnCount * _rowCount; i++) {
      
      // initialize & configure the card button
      UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      [btn setBackgroundImage:[ButtonGridView cardImage] forState:UIControlStateNormal];
      [btn addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
      [btn setTintColor:[UIColor clearColor]];  // iOS9 seems to throw a blue tint on UIButtonTypeRoundedRect
      
      // add the button to the cardButtonArray & to the UIView
      [_cardButtonArray addObject:btn];
      [self addSubview:btn];
    }
  }
  return self;
}

#pragma mark - Layout

- (CGSize)preferredSizeForWidth:(CGFloat)width
{
  CardLayoutInfo layoutInfo = [self layoutInfoForWidth:width];
  
  return CGSizeMake(layoutInfo.gridWidth, layoutInfo.gridHeight);
}

- (CardLayoutInfo)layoutInfoForWidth:(CGFloat)width
{
  CGSize cardAssetSize = [[ButtonGridView cardImage] size];
  CGFloat availableCardSpan = (width - 2 * HORIZONTAL_INSET);
  CGFloat cardWidth = roundf(availableCardSpan / (_columnCount + (_columnCount - 1) * CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH));
  CGFloat cardAspectRatio = cardAssetSize.height / cardAssetSize.width;
  CGFloat cardHeight = roundf(cardWidth * cardAspectRatio);
  CGFloat cardBuffer = roundf(CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH * cardWidth);
  CGFloat gridHeight = 2 * VERTICAL_INSET + cardHeight * _rowCount + cardBuffer * (_rowCount - 1);
  
  CardLayoutInfo layoutInfo;
  layoutInfo.cardHeight = cardHeight;
  layoutInfo.cardWidth  = cardWidth;
  layoutInfo.cardBuffer = cardBuffer;
  layoutInfo.gridHeight = gridHeight;
  layoutInfo.gridWidth  = width;
  
  return layoutInfo;
}

static const float HORIZONTAL_INSET = 20;
static const float VERTICAL_INSET = 20;
static const float CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH = 0.2;

- (void)layoutSubviews
{
  CardLayoutInfo layoutInfo = [self layoutInfoForWidth:self.bounds.size.width];
  
  // layout UIButtons in _cardButtonArray
  for (UIButton *button in _cardButtonArray) {
    
    CGRect buttonFrame = (CGRect){ CGPointZero, layoutInfo.cardWidth, layoutInfo.cardHeight };
    
    NSUInteger buttonIndex        = [_cardButtonArray indexOfObjectIdenticalTo:button];
    NSUInteger cardColumnPosition = buttonIndex % _columnCount;
    NSUInteger cardRowPosition    = buttonIndex / _columnCount;
    
    buttonFrame.origin.x = HORIZONTAL_INSET + cardColumnPosition * layoutInfo.cardWidth + cardColumnPosition * layoutInfo.cardBuffer;
    buttonFrame.origin.y = VERTICAL_INSET + cardRowPosition * layoutInfo.cardHeight + cardRowPosition * layoutInfo.cardBuffer;
    
    button.frame = buttonFrame;
  }
}

#pragma mark - user actions

- (void)buttonTouched:(UIButton *)sender
{
  NSUInteger cardButtonIndex = [_cardButtonArray indexOfObject:sender];
  
  // notify delegate cardButton has been touched
  [_delegate touchCardButtonAtIndex:cardButtonIndex];
  
}


#pragma mark - Instance Methods

- (void)updateBtnCards
{
  // for each card
  for (UIButton *cardButton in _cardButtonArray) {
    
    // find index of cardButton
    NSUInteger cardButtonIndex = [_cardButtonArray indexOfObject:cardButton];
    
    // update cardButton title
    [cardButton setAttributedTitle:[_delegate attributedTitleForCardAtIndex:cardButtonIndex] forState:UIControlStateNormal];
    cardButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cardButton.titleLabel.numberOfLines = 3;
    cardButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cardButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // update cardButton image
    [cardButton setBackgroundImage:[_delegate backgroundImageForCardAtIndex:cardButtonIndex] forState:UIControlStateNormal];
    
    // update cardButton shadow
    if ([_delegate shadowForCardAtIndex:cardButtonIndex]) {
      cardButton.layer.shadowColor = [UIColor blackColor].CGColor;
      cardButton.layer.shadowOffset = CGSizeMake(4.0,4.0);
      cardButton.layer.shadowOpacity = 1.0;
      cardButton.layer.shadowRadius = 0.0;
    } else {
      cardButton.layer.shadowOffset = CGSizeZero;
    }

    // update cardButton alpha
    [cardButton setAlpha:[_delegate alphaForCardAtIndex:cardButtonIndex]];
    
    // update cardButton enabled
    cardButton.enabled = [_delegate enableCardAtIndex:cardButtonIndex];
  }
}


#pragma mark - Class Methods

+ (UIImage *)cardImage
{
  return [UIImage imageNamed:@"cardback"];
}

@end
