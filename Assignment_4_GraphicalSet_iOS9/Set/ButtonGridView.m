//
//  ButtonGridView.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ButtonGridView.h"
#import "CardView.h"

typedef struct CardLayoutInfo {
  CGFloat  cardHeight;
  CGFloat  cardWidth;
  CGFloat  cardBuffer;
  CGFloat  gridHeight;
  CGFloat  gridWidth;
} CardLayoutInfo;


@implementation ButtonGridView


#pragma mark - Class Methods

// subclass MUST implement
+ (Class)cardViewClass
{
  NSAssert(NO, @"This should not be reached - abstract class");
  return Nil;
}


#pragma mark - Lifecycle

- (instancetype)initWithColumns:(NSUInteger)columnCount
                           rows:(NSUInteger)rowCount
                       delegate:(id<ButtonGridViewDelegate>)delegate
                           game:(MatchingGame *)game;
{
  self = [super initWithFrame:CGRectZero];
  
  if (self) {
    
    // create and configure instance variables
    self.cardArray = [[NSMutableArray alloc] init];
    self.columnCount = columnCount;
    self.rowCount = rowCount;
    self.delegate = delegate;
    
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
  CGFloat cardWidth = roundf(availableCardSpan / (self.columnCount + (self.columnCount - 1) * CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH));
  CGFloat cardAspectRatio = cardAssetSize.height / cardAssetSize.width;
  CGFloat cardHeight = roundf(cardWidth * cardAspectRatio);
  CGFloat cardBuffer = roundf(CARD_BUFFER_PERCENTAGE_OF_CARD_WIDTH * cardWidth);
  CGFloat gridHeight = 2 * VERTICAL_INSET + cardHeight * self.rowCount + cardBuffer * (self.rowCount - 1);
  
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
  
  // layout cards in self.cardArray
  for (CardView *card in self.cardArray) {
    
    CGRect cardFrame = (CGRect){ CGPointZero, layoutInfo.cardWidth, layoutInfo.cardHeight };
    
    NSUInteger index              = [self.cardArray indexOfObjectIdenticalTo:card];
    NSUInteger cardColumnPosition = index % self.columnCount;
    NSUInteger cardRowPosition    = index / self.columnCount;
    
    cardFrame.origin.x = HORIZONTAL_INSET + cardColumnPosition * layoutInfo.cardWidth + cardColumnPosition * layoutInfo.cardBuffer;
    cardFrame.origin.y = VERTICAL_INSET + cardRowPosition * layoutInfo.cardHeight + cardRowPosition * layoutInfo.cardBuffer;
    
    card.frame = cardFrame;
  }
}

#pragma mark - user actions

- (void)buttonTouched:(UIGestureRecognizer *)gr
{
  NSUInteger cardIndex = [self.cardArray indexOfObject:gr.view];
  
  // notify delegate cardButton has been touched
  [self.delegate touchCardButtonAtIndex:cardIndex];
}


#pragma mark - Instance Methods

// subclass must implement
- (void)updateCard
{
}

- (void)updateCardAtIndex:(NSUInteger)cardButtonIndex withCard:(Card *)card;
{
  CardView *cardView = [self.cardArray objectAtIndex:cardButtonIndex];
  
  [cardView updateCardProperties:card];
}


#pragma mark - Class Methods

+ (UIImage *)cardImage
{
  return [UIImage imageNamed:@"cardback"];
}

@end
